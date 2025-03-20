# Recursive Forward-Backward EDMD

This repository contains the simulation files for the paper:

**"Recursive Forward-Backward EDMD: Guaranteed Algebraic Search for Koopman Invariant Subspaces"**  
by Masih Haseli and Jorge Cortes, Published in IEEE ACCESS

## Description

This repository implements a novel data-driven algorithm for finding subspaces for Koopman-based models. The Recursive Forward-Backward EDMD method addresses a fundamental challenge in Koopman operator theory: finding finite-dimensional function spaces that are (approximately) invariant under the Koopman operator while guaranteeing the accuracy of the model for *all functions in the identified subspace (not just the eigenfunctions)*.

Key features of our approach:

- Introduces a data-driven algebraic search algorithm for finding appropriate finite-dimensional subspaces and building Koopman-based models on them
- Uses temporal consistency defined in [3] (a special case of invariance proximity, see [4,5]) as a way to evaluate subspace quality
- Implements a recursive decomposition strategy that separates subspaces based on prediction accuracy based on employing Extended Dynamic Mode Decomposition (EDMD) [6] forward and backward in time
- Provides tunable accuracy thresholds for different application requirements
- Includes theoretical guarantees for convergence and accuracy

## Requirements

- MATLAB (required for running all simulations, tested with MATLAB R2023b)

## Structure

Outline of the main components and folders in the project:

- `src/`: Core source code files containing the main algorithms (RFB-EDMD and TSSD)
- Example cases and demonstrations:
  - `VanderPolOscillator/`: Implementation for Van der Pol oscillator system
  - `DuffingEquation/`: Implementation for Duffing equation system
  - `YeastGlycolysis/`: Implementation for Yeast Glycolysis model
  - `NonlinearDiscreteTime/`: Implementation for a discrete-time nonlinear system
- Note: All `figures/` folders are excluded from the repository (see `.gitignore`)

Each example folder contains:

- Data acquisition scripts
- Parameter analysis implementations
- Visualization tools
- Results analysis scripts

## Getting Started

1. Clone this repository
2. Ensure you have MATLAB installed on your system
3. Navigate to the project directory in MATLAB and follow the instructions in each example

## Citation

If you use this code in your research, please cite:

[1] M. Haseli and J. Cortés, "Recursive Forward-Backward EDMD: Guaranteed Algebraic Search for Koopman Invariant Subspaces," IEEE ACCESS, 2025

Also, if you use the T-SSD algorithm (which we have used for comparison), please cite:

[2] M. Haseli and J. Cortés, "Generalizing dynamic mode decomposition: Balancing accuracy and expressiveness in Koopman approximations," Automatica, vol. 153, pp. 111001, 2023. [DOI](https://doi.org/10.1016/j.automatica.2023.111001)

## References

[3] M. Haseli and J. Cortés, "Temporal forward-backward consistency, not residual error, measures the prediction accuracy of extended dynamic mode decomposition," IEEE Control Systems Letters, vol. 7, pp. 649--654, 2022. [DOI](https://doi.org/10.1109/LCSYS.2022.3214476)

[4] M. Haseli and J. Cortés, "Modeling Nonlinear Control Systems via Koopman Control Family: Universal Forms and Subspace Invariance Proximity," [arXiv:2307.15368](https://arxiv.org/abs/2307.15368), 2023.

[5] M. Haseli and J. Cortés, "Invariance Proximity: Closed-Form Error Bounds for Finite-Dimensional Koopman-Based Models," [arXiv:2311.13033](https://arxiv.org/abs/2311.13033), 2023.

[6] M. O. Williams, I. G. Kevrekidis, and C. W. Rowley, "A data-driven approximation of the koopman operator: Extending dynamic mode decomposition," Journal of Nonlinear Science, vol. 25, pp. 1307--1346, 2015. [DOI](https://doi.org/10.1007/s00332-015-9258-5)
