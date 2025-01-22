%% Generate All Plots Script
% This script generates all visualization plots for the Duffing equation analysis
% Assumes that all necessary data has been pre-computed and saved in the
% saved_data directory through prior execution of data_acquisition.m and
% parameter sweep analysis.

clear
close all
clc

%% 1. Vector Field Visualization
disp('Step 1/4: Generating vector field visualization...');
vector_field_plot;
disp('Vector field visualization complete.');

%% 2. Eigenfunction Visualization
disp('Step 2/4: Generating eigenfunction visualizations...');
plot_eigenfunctions;
disp('Eigenfunction visualization complete.');

%% 3. Dictionary Error Analysis
disp('Step 3/4: Generating dictionary error plots...');
plot_relative_dictionary_error_on_state_space;
disp('Dictionary error analysis complete.');

%% 4. Subspace Dimension Analysis
disp('Step 4/4: Generating subspace dimension plots...');
plot_identified_subspace_dimensions;
disp('Subspace dimension analysis complete.');

disp('All plots generated successfully!');
