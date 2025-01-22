% Written by Masih Haseli as a part of the work available online at https://doi.org/10.1016/j.automatica.2023.111001
function [C] = Tunable_SSD_efficient(DX,DY,epsilon_value)
% TUNABLE_SSD_EFFICIENT Finds a basis matrix for epsilon_value-apart subspaces
%
% This function implements an efficient algorithm to find a matrix C such that 
% range(DX*C) and range(DY*C) are epsilon_value-apart. The algorithm iteratively refines
% the basis until the desired separation is achieved or no non-trivial basis exists.
%
% Inputs:
%   DX  - Dictionary matrix evaluated on data at time t, D(X)
%   DY  - Dictionary matrix evaluated on data at time t+1, D(Y)
%   epsilon_value - Tolerance parameter defining the desired subspace separation (also known as invariance proximity)
%
% Output:
%   C   - Basis matrix achieving epsilon_value-separation between subspaces
%         Returns 0 if no non-trivial basis exists
%
% Algorithm Steps:
%   1. Initialize basis matrix C as identity
%   2. Iteratively:
%      a. Compute orthonormal bases for current subspaces
%      b. Calculate difference of projection matrices
%      c. Find eigenvectors with small eigenvalues
%      d. Update basis using symmetric intersection
%   3. Terminate when convergence achieved or no non-trivial solution exists
%
% Reference: Haseli, M. et al. (2023) - https://doi.org/10.1016/j.automatica.2023.111001

% Initialize matrices and iteration counter
A = DX;
B = DY;
C = eye(size(A,2));
iter = 0;

while 1
    % Update iteration counter
    iter = iter + 1;
    
    % Step 1: Compute orthonormal bases for current subspaces
    % This reduces computational complexity and improves numerical stability
    Aorth = orth(A);
    Borth = orth(B);
    
    % Calculating the Hmatrix (It is the same H_i in Section 8 of the paper (Step 6.a of the modified algorithm))
    Hmatrix = orth([Aorth,Borth]);  % Combined basis matrix
    
    % Step 2: Calculate difference of projection matrices
    % This measures the separation between the subspaces
    Areduced = Hmatrix'*Aorth;
    Breduced = Hmatrix'*Borth;
    G = Areduced*Areduced' - Breduced*Breduced';
    
    % Step 3: Find eigenvectors with eigenvalues <= epsilon_value
    % Using SVD for better numerical stability than eigendecomposition (Note that this matrix is always real and symmetric)
    [~,Sigma,V] = svd(G);
    V = V(:,diag(Sigma) <= epsilon_value);
    
    if isempty(V)
        % No vectors satisfy the epsilon_value-separation criterion (i.e. the intersection is the trivial zero subspace)
        C = 0;
        break
    end
    
    % Step 4: Update basis using symmetric intersection
    % 1e-10 threshold provides robustness against numerical errors
    E = Symmetric_intersection_threshold(Hmatrix*V,A,B,1e-10);
    
    % Update matrices with new basis
    C = C*E;
    A = A*E;
    B = B*E;
    
    if E == 0
        % No non-trivial intersection exists
        C = 0;
        break
    end
    
    if size(E,1) <= size(E,2)
        % Convergence achieved - basis cannot be further reduced
        break
    end
end



