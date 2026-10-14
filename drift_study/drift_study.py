"""Measure how an unlocked environment drifts over time.

Solves the same manifest as if it were each of a series of dates, using the
Pixi workspace option exclude-newer, and compares each environment to the
first. The first environment stands in for the one that a lock file written on
the start date would have kept for every later date.

It is an approximation of that lock file: the solves use today's repodata, and
conda-forge patches the dependency metadata of published packages and moves
broken builds off its main label after the fact. So a solve today with
exclude-newer set to a past date can differ from a solve made on that date.

Each package is compared by version and build. conda-forge rebuilds hundreds
of packages every day without changing their versions, so rebuilds are counted
separately from version changes, which are what change the dependency tree.

Only lock files are written (pixi lock --no-install), so no packages are
downloaded, only the repodata.
"""

import argparse
import calendar
import csv
import datetime
import os
import re
import subprocess
import tempfile
import tomllib
from pathlib import Path

MANIFEST = Path(__file__).parent / "pixi.toml"
OUTPUT = Path(__file__).parent / "drift_study.csv"
# Packages whose versions are shown in the summary table
KEY_PACKAGES = ["python", "pytorch", "torchvision", "numba-cuda", "cuda-version"]
# Packages that only distribute data, whose calendar versions change with every
# data update rather than with the software
DATA_PACKAGES = {"ca-certificates", "tzdata"}
CATEGORIES = [
    "identical",
    "rebuild only",
    "patch version",
    "major/minor version",
    "data update",
    "added",
    "removed",
]


def snapshot_dates(start, end, months):
    """Yield the dates from start to end that are a multiple of months apart.

    The day of the month is kept where the month has it, and is otherwise the
    last day of the month (e.g. a start of 2025-01-31 gives 2025-02-28).
    """
    for step in range((end.year - start.year) * 12 + end.month - start.month + 1):
        if step % months:
            continue
        year, month = divmod(start.month - 1 + step, 12)
        year += start.year
        day = min(start.day, calendar.monthrange(year, month + 1)[1])
        date = datetime.date(year, month + 1, day)
        if date <= end:
            yield date


def parse_lock(lock_text):
    """Return {name: (version, build)} of the conda packages in a lock file."""
    # The manifest has a single environment and platform, so every conda
    # package URL in the lock file belongs to it.
    urls = set(re.findall(r"^\s*- conda: (\S+)$", lock_text, flags=re.MULTILINE))
    packages = {}
    for url in urls:
        # Conda package file names are <name>-<version>-<build>.conda,
        # where only the name can contain dashes
        filename = (
            url.rsplit("/", 1)[-1].removesuffix(".conda").removesuffix(".tar.bz2")
        )
        name, version, build = filename.rsplit("-", 2)
        packages[name] = (version, build)
    return packages


def solve(date, workdir):
    manifest_text = MANIFEST.read_text()
    if "exclude-newer" in tomllib.loads(manifest_text)["workspace"]:
        raise ValueError(f"{MANIFEST} must not set exclude-newer")
    # Add exclude-newer as the first key of the [workspace] table
    manifest_text = re.sub(
        r"^\[workspace\].*$",
        lambda match: f'{match.group(0)}\nexclude-newer = "{date.isoformat()}"',
        manifest_text,
        count=1,
        flags=re.MULTILINE,
    )
    # Without exclude-newer every snapshot would be solved against today's
    # packages and show no drift, so check that it was added
    workspace = tomllib.loads(manifest_text)["workspace"]
    if workspace.get("exclude-newer") != date.isoformat():
        raise ValueError(f"Could not add exclude-newer to {MANIFEST}")
    manifest = workdir / "pixi.toml"
    manifest.write_text(manifest_text)
    # pixi run sets PIXI_EXE to the pixi that is running the task
    pixi = os.environ.get("PIXI_EXE", "pixi")
    result = subprocess.run(
        [pixi, "lock", "--no-install", "--manifest-path", str(manifest)],
        # The return code is checked below to report pixi's error message
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(f"Solve for {date} failed:\n{result.stderr}")
    return parse_lock((workdir / "pixi.lock").read_text())


def classify(name, package, reference):
    """Return the CATEGORIES entry for how a package differs from its reference."""
    if package is None:
        return "removed"
    if reference is None:
        return "added"
    if package == reference:
        return "identical"
    (version, _), (reference_version, _) = package, reference
    if version == reference_version:
        return "rebuild only"
    if name in DATA_PACKAGES:
        return "data update"
    # The first two version components are the major and minor version. For
    # calendar versioned packages (e.g. mkl 2025.3.1) they are the year and
    # release, so a new year is counted as a new major version.
    if version.split(".")[:2] == reference_version.split(".")[:2]:
        return "patch version"
    return "major/minor version"


def count_categories(packages, reference):
    """Count the packages in each of CATEGORIES compared to the reference.

    A package that is replaced by one with another name counts as removed and added.
    """
    counts = dict.fromkeys(CATEGORIES, 0)
    for name in packages.keys() | reference.keys():
        counts[classify(name, packages.get(name), reference.get(name))] += 1
    return counts


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--start", type=datetime.date.fromisoformat, default=datetime.date(2025, 1, 1)
    )
    parser.add_argument(
        "--end", type=datetime.date.fromisoformat, default=datetime.date.today()
    )
    parser.add_argument(
        "--months", type=int, default=1, help="months between snapshots"
    )
    parser.add_argument("--output", type=Path, default=OUTPUT)
    args = parser.parse_args()
    if args.months < 1:
        parser.error("--months must be at least 1")
    if args.start > args.end:
        parser.error("--start must not be after --end")

    # Write each snapshot as soon as it is solved, so that the results of the
    # completed solves are kept if a later one fails
    snapshots = {}
    with (
        tempfile.TemporaryDirectory() as tmpdir,
        args.output.open("w", newline="") as csv_file,
    ):
        # The csv module defaults to CRLF line endings, use LF like the repository
        writer = csv.writer(csv_file, lineterminator="\n")
        writer.writerow(["date", "name", "version", "build"])
        for date in snapshot_dates(args.start, args.end, args.months):
            workdir = Path(tmpdir) / date.isoformat()
            workdir.mkdir()
            snapshots[date] = solve(date, workdir)
            for name, (version, build) in sorted(snapshots[date].items()):
                writer.writerow([date.isoformat(), name, version, build])
            csv_file.flush()

    baseline = snapshots[args.start]
    print(f"Packages compared to the {len(baseline)} packages on {args.start}")
    print(" | ".join(["date", "packages", *CATEGORIES, *KEY_PACKAGES]))
    for date, packages in snapshots.items():
        counts = count_categories(packages, baseline)
        versions = [packages.get(name, ("-",))[0] for name in KEY_PACKAGES]
        row = [date.isoformat(), len(packages), *counts.values(), *versions]
        print(" | ".join(str(value) for value in row))

    print(f"\nPer package results written to {args.output}")


if __name__ == "__main__":
    main()
