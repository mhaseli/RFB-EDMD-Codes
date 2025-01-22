%%% FB-EDMD on Yeast Glycolysis Analysis

%% Loading data and applying the dictionary

clear
close all
clc
addpath('utils/')
load('yeastGlycolysisData.mat');

% creating the dictionary functions of all monomials upto degree 8
dictionary = createVectorValuedMonomialFunc(7,4);

% applying the dictionary on data matrices
DX = dictionary(X);
DY = dictionary(Y);


% scale such that Columns of DX become orthogonal (this is to deal with ill-conditioned matrices)
Scaling_matrix = DX\orth(DX);

% scaled dictionary snapshots
DX = DX*Scaling_matrix;
DY = DY*Scaling_matrix;

% redefining the dictionary in the new coordinates
dictionary = @(point) dictionary(point) * Scaling_matrix;

%% Applying FB-EDMD with different values of epsilon

% vector for values of eplsion
eps = [.0001, 0.001,.01:.01:1];



% initializing a vector for dimension of the identified subspaces
subspace_dim = zeros(size(eps));


% creating a cell for the output of our algorithm
C_cell = cell(size(eps));


% applying the FB-EDMD method for each value of epsilon
for ii = 1:length(eps)
    ii % this is just to see the progress (comment out if you don't like it)

    % applying the FB-EDMD algorithm
    C_cell{ii} = FB_EDMD_onestep(DX,DY,eps(ii));    % This is the theoretical algorithm that can be sensistive to round-off errors
    % C_cell{ii} = FB_EDMD_onestep_svd(DX,DY,eps(ii));    % This is a more numerically robust version based on SVD as opposed to eigendecomposition


    % update the dimension of the identified subspace
    subspace_dim(ii) = size(C_cell{ii},2);
end

save('yeastGlycolysisData_FB_EDMD.mat', 'C_cell', 'subspace_dim', 'eps', 'dictionary', 'DX', 'DY');