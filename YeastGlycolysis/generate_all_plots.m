%% Generate All Plots Script
% This script generates visualization plots for analyzing the RFB-EDMD and T-SSD methods
% applied to the Yeast Glycolysis system. It assumes all necessary data has been 
% pre-computed and saved in the saved_data directory.
%
% The script generates:
% 1. Subspace dimension analysis plots comparing RFB-EDMD and T-SSD
% 2. Statistical error analysis plots for RFB-EDMD predictions

clear
close all
clc

%% 1. Subspace Dimension Analysis
disp('Step 1/2: Generating subspace dimension plots...');
plot_identified_subspace_dimensions;
disp('Subspace dimension analysis complete.');

%% 2. Statistical Error Analysis 
disp('Step 2/2: Generating statistical error plots...');
plot_statistical_error_on_test_data;
disp('Statistical error analysis complete.');

disp('All plots generated successfully!');
