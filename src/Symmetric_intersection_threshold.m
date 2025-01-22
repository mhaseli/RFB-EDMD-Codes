% Written by Masih Haseli as a part of the work available online at https://doi.org/10.1016/j.automatica.2023.111001
function [E] = Symmetric_intersection_threshold(V,A,B,tol)
% SYMMETRIC_INTERSECTION_THRESHOLD Finds a basis for the symmetric intersection of subspaces
%
% This function computes a matrix E with maximum number of columns such that 
% both range(AE) and range(BE) are contained within range(V). It uses SVD-based
% methods to handle numerical stability and approximate subspace computations.
%
% Inputs:
%   V   - Matrix defining the target subspace
%   A   - First matrix for subspace intersection
%   B   - Second matrix for subspace intersection
%   tol - Tolerance threshold for singular value truncation
%
% Output:
%   E   - Matrix whose columns form a basis for the symmetric intersection
%         Returns 0 if no valid basis exists
%
% Algorithm:
%   1. Checks dimensional compatibility of inputs
%   2. Computes null space of [V,A] using SVD
%   3. Uses relative singular values for numerical rank determination
%   4. Projects B onto the computed null space
%   5. Constructs orthonormal basis for final result
%
% Reference: 
%   Haseli, M. et al. (2023) - https://doi.org/10.1016/j.automatica.2023.111001

% Input validation
if size(A) ~= size(B)
    error("A \& B must have the same size.")
elseif size(V,1) ~= size(A,1)
    error("V \& A must have the same number of rows.")
end

% Step 1: Compute null space of [V,A] using SVD
[~,Sigma,W] = svd([V,A],0);

% Step 2: Determine numerical rank using relative singular values
% Compute cumulative energy of singular values from largest to smallest
rel_singular_value = cumsum(diag(Sigma),'reverse')/sum(diag(Sigma));
% Remove singular vectors corresponding to negligible singular values
W(:,rel_singular_value>tol) = [];

if isempty(W)
    % No valid null space exists - intersection is the trivial zero subspace
    E = 0;
else
    % Step 3: Extract relevant portion of null space for matrix A
    W_A = W(size(V,2)+1:end,:);
    
    % Step 4: Prune B onto the computed null space by repeating the SVD process
    [~,Sigma,Z] = svd([V,B * W_A],0);
    rel_singular_value = cumsum(diag(Sigma),'reverse')/sum(diag(Sigma));
    Z(:,rel_singular_value>tol) = [];
    
    if isempty(Z)
        % No valid intersection exists after B projection and the intersection is the trivial zero subspace
        E = 0;
    else
        % Step 5: Construct final orthonormal basis for the intersection
        E = orth(W_A * Z(size(V,2)+1:end,:));
    end
end

