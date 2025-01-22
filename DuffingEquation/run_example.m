%% Run Example Script for Duffing Equation Analysis
% This script executes the complete analysis pipeline for the Duffing equation
% system using RFB-EDMD and TSSD algorithms.

clear
close all
clc

%% 1. Load Pre-generated Data
disp('Step 1/7: Generating Duffing equation data...');
data_acquisition;
disp('Data generation complete.');

%% 2. Generate Vector Field Plot
disp('Step 2/7: Generating vector field visualization...');
vector_field_plot;
disp('Vector field visualization complete.');

%% 3. Run RFB-EDMD Parameter Sweep Analysis
disp('Step 3/7: Running parameter sweep analysis with RFB-EDMD...');
parameter_sweep_RFBDMD;
disp('RFB-EDMD parameter sweep analysis complete.');

%% 4. Run TSSD Parameter Sweep Analysis
disp('Step 4/7: Running parameter sweep analysis with TSSD...');
parameter_sweep_TSSD;
disp('TSSD parameter sweep analysis complete.');

%% 5. Generate Eigenfunction Plots
disp('Step 5/7: Generating eigenfunction visualizations...');
plot_eigenfunctions;
disp('Eigenfunction visualization complete.');

%% 6. Plot Dictionary Error Analysis
disp('Step 6/7: Generating dictionary error plots...');
plot_relative_dictionary_error_on_state_space;
disp('Dictionary error analysis complete.');

%% 7. Plot Subspace Dimension Analysis
disp('Step 7/7: Generating subspace dimension plots...');
plot_identified_subspace_dimensions;
disp('Subspace dimension analysis complete.');

disp('All analysis complete!');
