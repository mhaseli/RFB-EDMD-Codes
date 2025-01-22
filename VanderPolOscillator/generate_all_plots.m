%% Generate All Plots Script
% This script generates all visualization plots for the Van der Pol oscillator analysis
% Assumes that all necessary data has been pre-computed and saved in the
% saved_data directory through prior execution of data_acquisition.m and
% parameter sweep analysis.

clear
close all
clc

%% 1. Vector Field Visualization
disp('Step 1/6: Generating vector field visualization...');
vector_field_plot;
disp('Vector field visualization complete.');

%% 2. Eigenfunction Visualization
disp('Step 2/6: Generating eigenfunction visualizations...');
plot_eigenfunctions;
disp('Eigenfunction visualization complete.');

%% 3. Dictionary Error Analysis
disp('Step 3/6: Generating dictionary error plots...');
plot_relative_dictionary_error_on_state_space;
disp('Dictionary error analysis complete.');

%% 4. Subspace Dimension Analysis
disp('Step 4/6: Generating subspace dimension plots...');
plot_identified_subspace_dimensions;
disp('Subspace dimension analysis complete.');

%% 5. Motivating Example: EDMD Eigenfunction Analysis
disp('Step 5/6: Generating EDMD eigenfunction analysis plots...');
motivating_example_EDMD_eigenfunction_plots;
disp('EDMD eigenfunction analysis complete.');

%% 6. Motivating Example: EDMD Residual Error Sensitivity to Change of Basis
disp('Step 6/6: Generating EDMD residual error sensitivity plots...');
motivating_example_sensitivity_of_EDMD_residual_error;
disp('EDMD residual error sensitivity analysis complete.');

disp('All plots generated successfully!');
