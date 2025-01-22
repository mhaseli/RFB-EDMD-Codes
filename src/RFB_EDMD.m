function [C] = RFB_EDMD(DX, DY, epsilon_value)
% RFB_EDMD Recursive Forward-Backward Extended Dynamic Mode Decomposition
%
% This function implements the RFB-EDMD algorithm to find a reduced basis
% that better represents the dynamics of a system by iteratively removing
% directions associated with large reconstruction errors.
%
% Inputs:
%   DX  - Matrix of Dictionary measurements at time t
%   DY  - Matrix of Dictionary measurements at time t+1
%   epsilon_value - Accuracy parameter for the RFB-EDMD algorithm (bounding the invariance proximity)
%
% Output:
%   C   - Matrix representation of the reduced basis
%
% Algorithm:
%   1. Computes forward and backward EDMD
%   2. Analyzes reconstruction error through eigendecomposition
%   3. Iteratively removes directions with large errors
%   4. Continues until all eigenvalues are below threshold or basis vanishes
%


A = DX;
B = DY;
C = eye(size(A,2));  % Initialize the reduced basis matrix as the identity matrix
iter = 0;

while 1
    % Update iteration counter
    iter = iter + 1;
    
    % Compute forward and backward EDMD matrices
    Kb = B\A;    % Backward EDMD matrix
    Kf = A\B;    % Forward EDMD matrix
    
    % Compute the consistency matrix
    Mc = eye(size(Kf)) - Kf*Kb;  % Measures consistency between forward and backward operators
    
    % Eigendecomposition of the consistency matrix
    [V, Lambda] = eig(Mc);
    
    % Extract real parts (Note that the eigendecomposition of the consistency matrix is always real, the small imaginary part is due to numerical errors and should be removed)
    eigvals = real(diag(Lambda));
    eigvecs = real(V);
    
    % Find maximum eigenvalue corresponding to the largest prediction error
    eigval_max = max(eigvals);
    
    if eigval_max > epsilon_value^2
        % Remove directions with large reconstruction errors
        V = orth(eigvecs(:,eigvals < eigval_max));
        
        if isempty(V)
            % If no directions remain, algorithm returns trivial solution equal to zero
            C = 0;
            break
        else
            % Prune the space and update the basis and dictionary matrices
            C = C * V;
            A = A * V;
            B = B * V;
        end
    else
        % Convergence achieved - all eigenvalues below threshold
        break
    end
end



