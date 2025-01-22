function vectorValuedMonomialFunc = createVectorValuedMonomialFunc(numVariables, maxDegree)
% Generates a function handle for a vector-valued function of monomials
% that can be applied to matrices of data. Each column in the input matrix
% represents the values of one variable, and each row represents an observation.
%
% Args:
%   numVariables (int): The number of variables in the monomials.
%   maxDegree (int): The maximum degree of the monomials.
%
% Returns:
%   vectorValuedMonomialFunc (function_handle): A function handle that,
%       when called with a matrix of variable values, returns a matrix where
%       each column is the result of one of the monomials for all observations.

% Generate the matrix of exponent combinations using the provided function.
exponentMatrix = generateExponentMatrix(numVariables, maxDegree);

% Define the vector-valued function handle to operate on matrices.
vectorValuedMonomialFunc = @(dataMatrix) arrayfun(@(rowIdx) ...
    prod(dataMatrix.^exponentMatrix(rowIdx, :), 2), 1:size(exponentMatrix, 1), 'UniformOutput', false);

% Concatenate the results into a single matrix.
vectorValuedMonomialFunc = @(dataMatrix) cell2mat(vectorValuedMonomialFunc(dataMatrix));
end
