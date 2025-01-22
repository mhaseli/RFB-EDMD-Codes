# Duffing Equation Analysis using RFB-EDMD and TSSD

This repository contains MATLAB scripts for analyzing the Duffing equation using Recursive Forward-Backward Extended Dynamic Mode Decomposition (RFB-EDMD) and Tunable Symmetric Subspace Decomposition (TSSD) algorithms. The TSSD algorithm is implemented based on the work by Haseli et al. ([doi:10.1016/j.automatica.2023.111001](https://doi.org/10.1016/j.automatica.2023.111001)).

## Quick Start

There are two ways to use this repository:

1. **Complete Analysis Pipeline**:
   - Run `run_example.m` to execute the full analysis
   - Note: This will take significant computation time as it runs both algorithms hundreds of times for parameter sweeps to compare the identified subspaces with different epsilon values
   - Note: In practical applications, you would run each algorithm only once with your chosen parameter values

2. **Plot Generation Only**:
   - If you just want to generate plots using pre-computed data, run `generate_all_plots.m`
   - This requires the data files to exist in the `saved_data/` directory

## Script Descriptions

### Main Execution Script

- `run_example.m`: Master script that executes the complete analysis pipeline in sequence. This should be your starting point.

### Analysis Pipeline Scripts

1. **Data Generation**
   - `data_acquisition.m`: Generates synthetic data from the Duffing equation for subsequent analysis
   - Creates trajectories with random initial conditions
   - Saves data to `saved_data/trajectory_data.mat`

2. **Parameter Analysis**
   - `parameter_sweep_RFBDMD.m`: Implements RFB-EDMD algorithm
   - `parameter_sweep_TSSD.m`: Implements TSSD algorithm
   - Both perform parameter sweep analysis with varying epsilon values
   - Save results to `saved_data/RFB_EDMD_data.mat` and `saved_data/TSSD_data.mat` respectively

3. **Visualization Scripts**
   - `plot_eigenfunctions.m`: Generates visualizations of eigenfunction magnitudes, phases, and prediction errors
   - `plot_relative_dictionary_error_on_state_space.m`: Creates heatmaps of prediction errors across state space
   - `plot_identified_subspace_dimensions.m`: Plots the relationship between epsilon values and subspace dimensions
   - `vector_field_plot.m`: Creates publication-quality vector field visualizations of the Duffing system dynamics
     - Generates normalized vector field over domain x₁, x₂ ∈ [-2, 2]

## Output Structure

The scripts generate several directories for organizing output:

- `saved_data/`: Contains all computed data and analysis results
- `figures/`: Contains all generated visualizations
  - `figEigenfunction/`: Eigenfunction plots
  - `figRelative/`: Dictionary error visualizations
  - `figDimension/`: Subspace dimension analysis plots
  - `figVectorField/`: Vector field visualizations of the Duffing system

## Note

Each script can be run independently if the required data files exist, but it's recommended to use `run_example.m` for the complete analysis pipeline.

**Hardware Compatibility**: Results are not guaranteed on AMD CPUs due to potential numerical precision differences. The algorithms have been primarily tested and validated on Intel processors and Apple M-series chips.

**MATLAB Version**: The code has been tested using MATLAB version R2023b.
