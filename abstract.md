# Abstract

Scientific researchers need reproducible software environments for complex applications that can run across heterogeneous computing platforms.
Modern open source tools, like Pixi [1], provide automatic reproducibility solutions for all dependencies while providing a high-level interface well suited for researchers.
This poster will provide a practical overview of using Pixi to easily create scientific and artificial intelligence (AI) and machine learning (ML) environments that benefit from hardware acceleration, across multiple machines and platforms.
The focus will be on CUDA applications, such as machine learning frameworks, and CUDA-enabled research software [2-4].

As AI/ML becomes a modern part of the scientific toolkit, the need to have robustly reproducible scientific computing environments that support hardware acceleration, e.g. with CUDA, becomes more important.
However, historically just installing a working CUDA environment on a single machine, let alone on multiple platforms with different requirements, could be a difficult task for non-experts.
This led to many scientific machine learning workflows being reliably runnable on only particular machines, and, even worse, with environments that were not reproducible across time.

With significant recent advancements by the NVIDIA open source team and the conda-forge open source community, the entire CUDA stack &mdash; from compilers to development libraries &mdash; is now distributed on conda-forge.
This significantly reduces the overhead to install CUDA dependencies, but packaging and distribution of binaries alone does not solve the problem of reproducibility.
With automatic multi-platform digest-level lock file support for all dependencies that are available on package indexes (like PyPI and conda-forge), highly efficient solving strategies, and high-level user interfaces, Pixi provides a missing piece to the scientific researcher toolkit.
The technology allows researchers to easily specify the hardware acceleration requirements they have, multiple different computational environments needed for their experiments, and required software dependencies.
They can then quickly solve for a multi-platform lock file of all the dependencies required, down to the compiler level.
This makes it possible to have multiple hardware-accelerated environments defined that are able to run hardware-accelerated workflows across heterogeneous machines with different GPU types and CUDA compatibility.

The poster will also cover practical recommendations for deployment of locked software environments into production computing environments on traditional batch computing systems (e.g. HTCondor, Slurm) as well as cloud-native computing systems (e.g. Kubernetes, commercial cloud instances) [5].
It will also provide examples and links to published resources that provide fully templated Linux container definition files for arbitrary Pixi workspaces and computing requirements.

## References

1. Pixi: Unified Software Development and Distribution for Robotics and AI. Tobias Fischer, Wolf Vollprecht, Bas Zalmstra, Ruben Arts, Tim de Jager, Alejandro Fontan, Adam D Hines, Michael Milford, Silvio Traversaro, Daniel Claes, Scarlett Raine. arXiv, November, 2025. [https://arxiv.org/abs/2511.04827](https://arxiv.org/abs/2511.04827)
1. Reproducible Machine Learning Workflows for Scientists with Pixi. Matthew Feickert, Ruben Arts, John Kirkham. Proceedings of 24th International SciPy Conference — SciPy 2025, July, 2025. DOI: [10.25080/nwuf8465](https://doi.org/10.25080/nwuf8465)
1. Reproducible Machine Learning Workflows for Scientists. Matthew Feickert. November, 2025. Retrieved 2026-08-06. [https://carpentries-incubator.github.io/reproducible-ml-workflows/](https://carpentries-incubator.github.io/reproducible-ml-workflows/) DOI: [10.5281/zenodo.17537698](https://doi.org/10.5281/zenodo.17537698)
1. Reproducible CUDA Accelerated Workflows for Scientists with Pixi. Matthew Feickert, Ruben Arts, Katrina Riehl. SciPy 2026 Tutorial, July 2026. Retrieved 2026-08-06. [https://matthewfeickert-talks.github.io/reproducible-cuda-workflows-with-pixi-scipy-2026/](https://matthewfeickert-talks.github.io/reproducible-cuda-workflows-with-pixi-scipy-2026/) DOI: [10.5281/zenodo.21829174](https://doi.org/10.5281/zenodo.21829174)
1. Template job submissions using GPUs in CHTC. University of Wisconsin–Madison Center for High Throughput Computing Facilitation Team. Retrieved 2026-08-06. [https://github.com/CHTC/templates-GPUs](https://github.com/CHTC/templates-GPUs)

## Connection to Mission, Goals, & Interests of US-RSE Community

This poster proposal is well positioned to support the US-RSE community's mission focus of providing technical and career development resources to support professional development by providing actionable best practices for reproducible scientific software environments throughout development and deployment to production computing.
As hardware accelerated computing environments have become increasingly more common in scientific research given the rise of machine learning and artificial intelligence as scientific tools, having the knowledge and abilities to seamlessly integrate CUDA-accelerated tooling into workflows in a reproducible manner is more important than ever.
This work, as seen in the supporting references, can support and benefit the ongoing work of the US-RSE community’s Education & Training Working Group.
This work is also aligned with the USRSE 2026 conference theme of "Advancing Science in the Age of AI" as it provides tooling and recommendations for leveraging the software necessary for delivering real research impact in AI/ML-supported science.
