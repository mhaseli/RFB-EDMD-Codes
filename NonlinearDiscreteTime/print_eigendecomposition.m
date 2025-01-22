%% Finding the Koopman eigenfunctions associated with Discrete-Time Nonlinear system on an invariant subspace
% This script performs eigendecomposition analysis using the RFB-EDMD  method to identify Koopman
% eigenfunctions for a nonlinear dynamical system.

%% Loading data and initialization
clear
close all
clc

% Add path to source directory containing RFB-EDMD implementation and utility functions
addpath('../src/')

% Load pre-computed data:
% - RFB_EDMD_data.mat: Contains the results of RFB-EDMD analysis
% - trajectory_data.mat: Contains the system trajectory information
load('saved_data/RFB_EDMD_data.mat');
load('saved_data/trajectory_data.mat');

% Transform state matrices using the dictionary mapping
% DX: Dictionary applied to current states
% DY: Dictionary applied to next states
DX = dictionary(X);
DY = dictionary(Y);

%% Compute EDMD Eigendecomposition
% Select the appropriate subspace identified by RFB-EDMD using epsilon parameter

subspace_index = 3;
fprintf('Selected subspace corresponds to epsilon = %.2e\n', epsilon_values(subspace_index));
C = rfb_C_cell{subspace_index};

% applying EDMD on the new subspace using the original data
K = (DX*C)\(DY*C);

% doing eigendecomposition on EDMD matrix
[eigvecs,eigvals] = eig(K);
eigvals = diag(eigvals);

% Transform eigenvectors back to the original dictionary basis
% This step is necessary to interpret the results in terms of the original observables
eigvecs_origbasis = Scaling_matrix * C * eigvecs;

%% Normalize eigenvectors for better visualization
% Note: This normalization is optional and doesn't affect the mathematical properties
% of the Koopman approximation

% Find elements with absolute value > 0.0001 for normalization reference
index_vec = zeros(1,size(eigvecs_origbasis,2));
for ii = 1: length(index_vec)
    colvec = abs(eigvecs_origbasis(:,ii));
    index_vec(ii) = min(colvec(colvec>.0001)); 
end

% Normalize eigenvectors using the identified reference values
eigenvectors_original_dictionary = eigvecs_origbasis* diag(1./index_vec);

%% Output Results
% Create directory for storing eigenfunction results
if ~exist('eigenfunctions', 'dir')
    mkdir('eigenfunctions');
end

% Open output file for writing results
fileID = fopen('eigenfunctions/eigenfunctions_output.txt', 'w');

% Convert dictionary to human-readable string format
Dictionary_display = Monomial_dictionary_display(dictionary_powers);

% Display and save each eigenfunction with its corresponding eigenvalue
% For each eigenfunction:
% 1. Convert to readable mathematical expression
% 2. Display to console
% 3. Save to file
for eig_number = 1:size(eigenvectors_original_dictionary, 2)
    eigenfunction = Eigenfunction_display(dictionary_powers, eigenvectors_original_dictionary(:, eig_number));
    eigenvalue = eigvals(eig_number);
    
    % Console output
    fprintf('Eigenfunction Number: %d\n', eig_number);
    fprintf('Eigenvalue: %f\n', eigenvalue);
    fprintf('Eigenfunction: %s\n', eigenfunction);
    fprintf('-----------------------------\n');
    
    % File output
    fprintf(fileID, 'Eigenfunction Number: %d\n', eig_number);
    fprintf(fileID, 'Eigenvalue: %f\n', eigenvalue);
    fprintf(fileID, 'Eigenfunction: %s\n', eigenfunction);
    fprintf(fileID, '-----------------------------\n\n');
end

% Close output file
fclose(fileID);