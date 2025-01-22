# Yeast Glycolysis Analysis using RFB-EDMD and TSSD

This repository contains MATLAB scripts for analyzing the Yeast Glycolysis system using Recursive Forward-Backward Extended Dynamic Mode Decomposition (RFB-EDMD) and Tunable Symmetric Subspace Decomposition (TSSD) algorithms. The TSSD algorithm is implemented based on the work by Haseli et al. ([doi:10.1016/j.automatica.2023.111001](https://doi.org/10.1016/j.automatica.2023.111001)).

## Quick Start

There are two ways to use this repository:

1. **Complete Analysis Pipeline**:
   - Run `run_example.m` to execute the full analysis pipeline
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
   - `data_acquisition.m`: Generates training data from the Yeast Glycolysis model
   - Creates trajectories with random initial conditions in the [0,1]⁷ space
   - Uses high-precision ODE integration for accurate simulation
   - Saves data to `saved_data/trajectory_data.mat`

2. **Parameter Analysis**
   - `parameter_sweep_RFBDMD.m`: Implements RFB-EDMD algorithm with parameter sweep
   - `parameter_sweep_TSSD.m`: Implements TSSD algorithm with parameter sweep
   - Both analyze algorithm behavior with different epsilon values
   - Save results to `saved_data/RFB_EDMD_data.mat` and `saved_data/TSSD_data.mat` respectively

3. **Visualization Scripts**
   - `plot_identified_subspace_dimensions.m`: Compares subspace dimensions identified by both methods
   - `plot_statistical_error_on_test_data.m`: Analyzes prediction accuracy on test data

## Output Structure

The scripts generate several directories for organizing output:

- `saved_data/`: Contains all computed data and analysis results
  - `trajectory_data.mat`: Training data and system parameters
  - `RFB_EDMD_data.mat`: RFB-EDMD analysis results
  - `TSSD_data.mat`: TSSD analysis results
- `figures/`: Contains all generated visualizations
  - `figError/`: Statistical error analysis plots
  - `figDimension/`: Subspace dimension comparison plots

## System Requirements

- **MATLAB Version**: Code tested using MATLAB R2023b

## Note

Each script can be run independently if the required data files exist, but it's recommended to use `run_example.m` for the complete analysis pipeline.

**Hardware Compatibility**: Results are not guaranteed on AMD CPUs due to potential numerical precision differences. The algorithms have been primarily tested and validated on Intel processors and Apple M-series chips.

**MATLAB Version**: The code has been tested using MATLAB version R2023b.
