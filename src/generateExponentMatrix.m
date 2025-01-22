function exponentMatrix = generateExponentMatrix(numVariables, maxDegree)
% Generates a matrix where each row represents a unique combination
% of exponents for each variable, given the number of variables and
% the maximum degree. The rows are sorted by the sum of degrees, and
% columns are arranged from last to first for aesthetic reasons.
%
% Args:
%   numVariables (int): The number of variables.
%   maxDegree (int): The maximum degree of the polynomial.
%
% Returns:
%   exponentMatrix (matrix): A matrix of size MxN, where M is the number
%       of combinations, and N is `numVariables`. Each row represents a
%       combination of exponents for the variables, sorted by the sum
%       of exponents and with columns rearranged for aesthetics.

% Initialize the matrix to store combinations of exponents.
exponentMatrix = zeros(1, numVariables);

% Recursively generate all combinations of exponents.
exponentMatrix = recurseExponents(numVariables, maxDegree, [], exponentMatrix);

% Remove the initial zero row used for initialization.
exponentMatrix(1, :) = [];

% Add a column with the sum of each row's elements.
sumColumn = sum(exponentMatrix, 2);
sortedMatrix = [sumColumn, exponentMatrix];

% Sort the rows based on the sum column.
sortedMatrix = sortrows(sortedMatrix);

% Remove the sum column before returning.
exponentMatrix = sortedMatrix(:, 2:end);

% Flip the columns from last to first for aesthetic reasons.
exponentMatrix = fliplr(exponentMatrix);
end