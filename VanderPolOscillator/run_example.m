%% Run Example Script for Van der Pol Oscillator Analysis
% This script executes the complete analysis pipeline for the Van der Pol oscillator
% system using RFB-EDMD and TSSD algorithms.

clear
close all
clc

%% 1. Load Pre-generated Data
disp('Step 1/9: Generating Van der Pol oscillator data...');
data_acquisition;
disp('Data generation complete.');

%% 2. Generate Vector Field Plot
disp('Step 2/9: Generating vector field visualization...');
vector_field_plot;
disp('Vector field visualization complete.');

%% 3. Run RFB-EDMD Parameter Sweep Analysis
disp('Step 3/9: Running parameter sweep analysis with RFB-EDMD...');
parameter_sweep_RFBDMD;
disp('RFB-EDMD parameter sweep analysis complete.');

%% 4. Run TSSD Parameter Sweep Analysis
disp('Step 4/9: Running parameter sweep analysis with TSSD...');
parameter_sweep_TSSD;
disp('TSSD parameter sweep analysis complete.');

%% 5. Generate Eigenfunction Plots
disp('Step 5/9: Generating eigenfunction visualizations...');
plot_eigenfunctions;
disp('Eigenfunction visualization complete.');

%% 6. Plot Dictionary Error Analysis
disp('Step 6/9: Generating dictionary error plots...');
plot_relative_dictionary_error_on_state_space;
disp('Dictionary error analysis complete.');

%% 7. Plot Subspace Dimension Analysis
disp('Step 7/9: Generating subspace dimension plots...');
plot_identified_subspace_dimensions;
disp('Subspace dimension analysis complete.');

%% 8. Motivating Example: EDMD Eigenfunction Analysis (Spurious Eigenfunctions)
disp('Step 8/9: Generating EDMD eigenfunction analysis plots...');
motivating_example_EDMD_eigenfunction_plots;
disp('EDMD eigenfunction analysis complete.');

%% 9. Motivating Example: EDMD Residual Error and Its Sensitivity to Change of Basis
disp('Step 9/9: Generating EDMD residual error sensitivity plots...');
motivating_example_sensitivity_of_EDMD_residual_error;
disp('EDMD residual error sensitivity analysis complete.');

disp('All analysis complete!');
