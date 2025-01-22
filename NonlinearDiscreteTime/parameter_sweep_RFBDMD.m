%% RFB-EDMD Algorithm Application for Discrete-Time Nonlinear Systems
% This script implements the Recursive Forward-Backward Extended Dynamic Mode 
% Decomposition (RFB-EDMD) algorithm for analyzing discrete-time nonlinear systems. 
% The algorithm is applied multiple times with varying epsilon values to analyze 
% sensitivity to this parameter.

%% Data Loading and Dictionary Application
clear
close all
clc

% Add path to source directory containing RFB-EDMD implementation and utility functions
addpath('../src');

% Load pre-processed system data from saved_data directory
load('saved_data/trajectory_data.mat');

% Define parameters for dictionary generation
numStateVars = 2;  % Number of state variables in the system
maxPolyDegree = 2; % Maximum degree of polynomial terms in dictionary.
                   % Note: Despite favorable theoretical properties, polynomials of high
                   % degrees can lead to ill-conditioned matrices and numerical instability

% Generate the powers of the monomial dictionary (needed for result interpretation)
dictionary_powers = generateExponentMatrix(numStateVars, maxPolyDegree);
% Generate dictionary functions comprising all monomials up to specified degree
% This creates a basis for approximating the Koopman operator
dictionary = createVectorValuedMonomialFunc(numStateVars, maxPolyDegree);

% Apply dictionary transformations to state matrices
DX = dictionary(X);  % Transform states at time k
DY = dictionary(Y);  % Transform states at time k+1

% Perform change of basis to improve numerical conditioning
% While RFB-EDMD is theoretically invariant to choice of basis functions,
% numerical stability is important in practice. By orthogonalizing the 
% dictionary columns, we ensure the matrices are well-conditioned without
% affecting the algorithm's mathematical properties.
Scaling_matrix = DX\orth(DX);

% Transform dictionary snapshots to orthogonalized basis, ensuring columns of DX
% are orthonormal. This improves numerical conditioning while preserving the
% underlying information.
DX = DX*Scaling_matrix;
DY = DY*Scaling_matrix;

% Redefine dictionary function to include scaling transformation
dictionary = @(point) dictionary(point) * Scaling_matrix;

%% RFB-EDMD Implementation with Parameter Sweep
% Define range of epsilon values for accuracy analysis
% Epsilon controls the accuracy threshold for identifying important features
% **NOTE: This sweep is performed for accuracy analysis only. In practice,
% a single epsilon value should be sufficient.**
epsilon_values = [.00001, 0.001,.01:.01:1];

% Initialize storage for algorithm results
rfb_subspace_dim = zeros(size(epsilon_values));    % Store RFB-EDMD subspace dimensions
rfb_C_cell = cell(size(epsilon_values));           % Store RFB-EDMD outputs

% Create progress indicator
progressbar = waitbar(0, 'Processing...'); 

% Inform user about multiple iterations
fprintf(['Applying RFB-EDMD algorithm %d times for accuracy analysis.\n' ...
         'Note: In practical applications, single iteration is typically sufficient.\n'], ...
         length(epsilon_values));

% Execute algorithm for each epsilon value
for ii = 1:length(epsilon_values)
    % Apply RFB-EDMD algorithm with current epsilon
    rfb_C_cell{ii} = RFB_EDMD(DX, DY, epsilon_values(ii));
    rfb_subspace_dim(ii) = size(rfb_C_cell{ii}, 2);
    
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

% Save RFB-EDMD results
save(fullfile(output_dir, 'RFB_EDMD_data.mat'), ...
     'rfb_C_cell', 'rfb_subspace_dim', 'epsilon_values', 'dictionary', 'dictionary_powers', 'Scaling_matrix');