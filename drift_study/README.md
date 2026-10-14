# Environment drift study

This study measures how much an environment changes over time when it is solved from a manifest without a lock file. It is the source of the "No lock file counterfactual" numbers on the poster.

## Method

[`drift_study.py`](drift_study.py) solves the manifest [`pixi.toml`](pixi.toml) as if it were each month from 2025-01-01 onwards, using the Pixi workspace option [`exclude-newer`](https://pixi.prefix.dev/latest/reference/pixi_manifest/), and compares every package of each environment to the 2025-01-01 environment. The 2025-01-01 environment stands in for what a lock file written on that date would have kept. Only lock files are written (`pixi lock --no-install`), so no packages are downloaded.

Each package is classified as identical, rebuilt (same version, new build), a patch version change, a major/minor version change, a data update (`ca-certificates` and `tzdata`), added, or removed. Rebuilds are counted separately as conda-forge rebuilds many packages every day without changing their versions.

The manifest has the dependencies of the [example workspace](../example/pixi.toml) for a single CUDA 12 platform, as CUDA 13 was not yet on conda-forge on 2025-01-01. The lower bounds are those that `pixi add` wrote with `exclude-newer = "2025-01-01"`.

## Version bounds

`pixi add` also writes upper bounds that follow Semantic Versioning, which for `0.x` releases allows only patch releases. Two of these were widened, as the release notes of the projects show no breaking changes to the public API that the example uses in that range:

- `torchvision` from `<0.21` to `<0.29.0`: up to 0.28 the only public API that was removed is video decoding and encoding (in 0.26), cf. the [torchvision releases](https://github.com/pytorch/vision/releases).
- `numba-cuda` from `<0.3` to `<0.31`: up to 0.30 the public `numba.cuda` API is kept, cf. the [numba-cuda repository](https://github.com/NVIDIA/numba-cuda). The user-facing changes are that the default compute capability is 7.5 (0.14) and that `numba.cuda.fp16` has to be imported explicitly (0.18).

The widened bounds change the results. Comparing the 2026-10-01 environment to the 2025-01-01 environment (113 packages):

| Upper bounds | Major/minor version changed | Removed | Added |
|---|---|---|---|
| Widened (as on the poster) | 67 | 24 | 39 |
| As written by `pixi add` | 62 | 13 | 20 |

With the `pixi add` bounds `torchvision` holds `pytorch` at 2.5.1 for the whole period, while most of the environment around it still changes.

## Limitations

The solves use today's repodata. conda-forge patches the dependency metadata of published packages and moves broken builds off its main label after the fact, so a solve today with `exclude-newer` set to a past date can differ from a solve that was made on that date.

## Usage

```console
pixi run drift-study --end 2026-10-01
```

The options `--start`, `--end`, `--months` (months between snapshots), and `--output` (the per package CSV, by default `drift_study.csv` next to the script) are described by `--help`.
