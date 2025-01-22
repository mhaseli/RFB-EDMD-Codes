%% Run Example Script for Discrete-Time Nonlinear System Analysis
% This script executes the complete analysis pipeline for the discrete-time
% nonlinear system using RFB-EDMD and TSSD algorithms.

clear
close all
clc

%% 1. Generate Training Data
disp('Step 1/6: Generating discrete-time system data...');
data_acquisition;
disp('Data generation complete.');

%% 2. Run RFB-EDMD Parameter Sweep Analysis
disp('Step 2/6: Running parameter sweep analysis with RFB-EDMD...');
parameter_sweep_RFBDMD;
disp('RFB-EDMD parameter sweep analysis complete.');

%% 3. Run TSSD Parameter Sweep Analysis
disp('Step 3/6: Running parameter sweep analysis with TSSD...');
parameter_sweep_TSSD;
disp('TSSD parameter sweep analysis complete.');

%% 4. Print Eigendecomposition Results
disp('Step 4/6: Computing and saving eigenfunction analysis...');
print_eigendecomposition;
disp('Eigenfunction analysis complete.');

%% 5. Plot Dictionary Error Analysis
disp('Step 5/6: Generating dictionary error plots...');
plot_relative_dictionary_error_on_state_space;
disp('Dictionary error analysis complete.');

%% 6. Plot Subspace Dimension Analysis
disp('Step 6/6: Generating subspace dimension plots...');
plot_identified_subspace_dimensions;
disp('Subspace dimension analysis complete.');

disp('All analysis complete!');
