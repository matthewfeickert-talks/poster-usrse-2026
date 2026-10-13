# Proposal Reviews

## Review 1

### Overall evaluation

SCORE: 3 (strong accept)

### Review text

Strongly aligned with the theme.It explicitly targets reproducible CUDA/AI-ML environments across heterogeneous hardware, and core RSE-mission work (reproducibility, deployment tooling). Concrete tool (Pixi) with real technical detail (multi-platform digest-level lock files, compiler-level dependency solving) and practical deployment guidance across batch and cloud-native systems. Abstract reads more as a practical tool overview/tutorial than an original case study, no quantitative results like adoption and time saved.

Suggestion - Add even one measured before/after (e.g., setup time or reproducibility failure rate) to move from "here's a useful tool" to demonstrated impact.

## Review 2

### Overall evaluation

SCORE: 2 (accept)

### Review text

This poster offers a clear practical overview of how Pixi can be used to build reproducible, hardware accelerated scientific software environments across heterogeneous computing platforms. It also addresses a long standing challenge in scientific computing: reliably installing and reproducing CUDA-enabled environments across machines, GPU types and time. The availability of the full CUDA stack on conda‑forge and Pixi’s digest‑level lock files represent meaningful improvements for reproducible scientific computing. The poster focuses on reproducibility for AI/ML workflows, especially those requiring GPU acceleration. The poster promises practical guidance, including deployment strategies for Slurm, HTCondor, Kubernetes, and cloud platforms, plus templated container definitions. Note: would be helpful to include more detail on potential limitations or edge cases (e.g., GPU driver compatibility, container runtime constraints).

## Review 3

### Overall evaluation

SCORE: 3 (strong accept)

### Review text

Is this poster relevant to the conference theme of “Advancing Science in the Age of AI” and/or relevant to the RSE community?

yes

What are strengths and weaknesses of the poster abstract?

This should be well received at the conference and stimulate some conversation around reproducible environments.

Do you have any constructive comments or feedback on the poster? Please provide suggestions that will foster discussion at the conference.

This abstract presents an approach to facilitate reproducible software environments across heterogeneous compute platforms, which is very much of current interest.

The writing is clear and concise, and provides a good base for interactive discussion on the topic and the tech the authors have utilised.
