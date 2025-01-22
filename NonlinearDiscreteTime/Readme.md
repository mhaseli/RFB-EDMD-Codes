# Discrete-Time Nonlinear System Analysis using RFB-EDMD and TSSD

This repository contains MATLAB scripts for analyzing a discrete-time nonlinear system using Recursive Forward-Backward Extended Dynamic Mode Decomposition (RFB-EDMD) and Tunable Symmetric Subspace Decomposition (TSSD) algorithms. The TSSD algorithm is implemented based on the work by Haseli et al. ([doi:10.1016/j.automatica.2023.111001](https://doi.org/10.1016/j.automatica.2023.111001)).

## Quick Start

There are two ways to use this repository:

**Complete Analysis Pipeline**:

- Run `run_example.m` to execute the full analysis
- Note: This will take significant computation time as it runs both algorithms hundreds of times for parameter sweeps to compare the identified subspaces with different epsilon values  
- Note: In practical applications, you would run each algorithm only once with your chosen parameter values

## Script Descriptions

### Main Execution Script

- `run_example.m`: Master script that executes the complete analysis pipeline in sequence.

### Analysis Pipeline Scripts

1. **Data Generation**
   - `data_acquisition.m`: Generates training data for the discrete-time nonlinear system

2. **Parameter Analysis**
   - `parameter_sweep_RFBDMD.m`: Implements RFB-EDMD algorithm
   - `parameter_sweep_TSSD.m`: Implements TSSD algorithm
   - Both perform parameter sweep analysis with varying epsilon values
   - Save results to `saved_data/RFB_EDMD_data.mat` and `saved_data/TSSD_data.mat` respectively

3. **Analysis and Visualization**
   - `print_eigendecomposition.m`: Computes and saves eigenfunction analysis
   - `plot_relative_dictionary_error_on_state_space.m`: Visualizes dictionary errors
   - `plot_identified_subspace_dimensions.m`: Analyzes subspace dimensions

## Output Structure

The scripts generate several directories for organizing output:

- `saved_data/`: Contains all computed data and analysis results
- `eigenfunctions/`: Contains eigenfunction analysis results
- `figures/`: Contains all generated visualizations
  - `figRelative/`: Dictionary error visualizations
  - `figDimension/`: Subspace dimension analysis plots

## Note

Each script can be run independently if the required data files exist, but it's recommended to use `run_example.m` for the complete analysis pipeline.

**Hardware Compatibility**: Results are not guaranteed on AMD CPUs due to potential numerical precision differences. The algorithms have been primarily tested and validated on Intel processors and Apple M-series chips.

**MATLAB Version**: The code has been tested using MATLAB version R2023b.
