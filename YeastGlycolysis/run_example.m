%% Run Example Script for Yeast Glycolysis Analysis
% This script executes the analysis pipeline for the Yeast Glycolysis system
% using RFB-EDMD and T-SSD algorithms.
%
% The analysis pipeline:
% 1. Generates training data
% 2. Performs parameter sweep analysis for both methods
% 3. Generates comparison plots

clear
close all
clc

%% 1. Generate Training Data
disp('Step 1/5: Generating Yeast Glycolysis training data...');
data_acquisition;
disp('Data generation complete.');

%% 2. Run RFB-EDMD Parameter Sweep Analysis
disp('Step 2/5: Running parameter sweep analysis with RFB-EDMD...');
parameter_sweep_RFBDMD;
disp('RFB-EDMD parameter sweep analysis complete.');

%% 3. Run TSSD Parameter Sweep Analysis
disp('Step 3/5: Running parameter sweep analysis with TSSD...');
parameter_sweep_TSSD;
disp('TSSD parameter sweep analysis complete.');

%% 4. Generate Subspace Dimension Analysis Plots
disp('Step 4/5: Generating subspace dimension plots...');
plot_identified_subspace_dimensions;
disp('Subspace dimension analysis complete.');

%% 5. Generate Statistical Error Analysis
disp('Step 5/5: Generating statistical error analysis...');
plot_statistical_error_on_test_data;
disp('Statistical error analysis complete.');

disp('All analysis complete!');
