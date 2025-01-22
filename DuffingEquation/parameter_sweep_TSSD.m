%% Tunable SSD Algorithm Application for Duffing Equation
% This script implements the Tunable Symmetric Subspace Decomposition (TSSD) 
% algorithm on the Duffing Equation system. The algorithm is applied multiple 
% times with varying epsilon values to analyze sensitivity to this parameter.

%% Data Loading and Dictionary Application
clear
close all
clc

% Add path to source directory containing TSSD implementation and utility functions
addpath('../src');


% Load pre-processed Duffing equation data from saved_data directory
load('saved_data/trajectory_data.mat');
% Load pre-processed RFB-EDMD data 
load('saved_data/RFB_EDMD_data.mat');

% Apply the dictionary to the state matrices
DX = dictionary(X);
DY = dictionary(Y);

%% TSSD Implementation with Parameter Sweep


% Initialize storage for algorithm results
tssd_subspace_dim = zeros(size(epsilon_values));   % Store TSSD subspace dimensions
tssd_C_cell = cell(size(epsilon_values));          % Store TSSD outputs

% Create progress indicator
progressbar = waitbar(0, 'Processing...'); 

% Inform user about multiple iterations
fprintf(['Applying Tunable SSD algorithm %d times for accuracy analysis.\n' ...
         'Note: In practical applications, single iteration is typically sufficient.\n'], ...
         length(epsilon_values));

% Execute algorithm for each epsilon value
for ii = 1:length(epsilon_values)
    % Apply Tunable SSD algorithm with current epsilon
    tssd_C_cell{ii} = Tunable_SSD_efficient(DX, DY, epsilon_values(ii));
    tssd_subspace_dim(ii) = size(tssd_C_cell{ii}, 2);
    
    % Update progress indicator
    waitbar(ii/length(epsilon_values), progressbar, ...
            sprintf('Progress: %d%%', round(100 * ii/length(epsilon_values))));
    pause(0.05);  % Brief pause for UI update
end

close(progressbar);

%% Save Results
% Create output directory if it doesn't exist
output_dir = 'saved_data';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Save Tunable SSD results
save(fullfile(output_dir, 'TSSD_data.mat'), ...
     'tssd_C_cell', 'tssd_subspace_dim');
