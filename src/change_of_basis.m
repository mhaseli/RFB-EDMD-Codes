function newMatrix = change_of_basis(matrix, alpha)
    %CHANGE_OF_BASIS Performs a linear transformation to the columns of a matrix
    %
    % This function implements a basis transformation where:
    % - The first column remains unchanged as the initial basis vector
    % - For each subsequent column i, the new vector is computed as:
    %   v_i_new = v_1 + alpha * v_i
    % where v_1 is the first column and v_i is the i-th column of the input matrix
    %
    % Syntax:
    %   newMatrix = change_of_basis(matrix, alpha)
    %
    % Inputs:
    %   matrix - An m-by-n numeric matrix where each column represents a vector
    %           in the original basis
    %   alpha  - A nonzero scalar coefficient that determines the linear
    %           combination weight for the transformation
    %
    % Outputs:
    %   newMatrix - An m-by-n matrix containing the vectors in the new basis,
    %               with the same dimensions as the input matrix


    % Input validation: Check if alpha is nonzero
    if alpha == 0
        error('Alpha parameter must be nonzero for a valid basis transformation');
    end

    % Initialize the output matrix with the same size as input
    newMatrix = matrix;

    % Get the dimensions of the input matrix
    [~, n] = size(matrix);

    % Apply the basis transformation to each column except the first
    for i = 2:n
        % Transform each vector using the formula: v_new = v_1 + alpha * v_i
        % where v_1 is the first column and v_i is the current column
        newMatrix(:, i) = matrix(:, 1) + alpha * matrix(:, i);
    end
end
