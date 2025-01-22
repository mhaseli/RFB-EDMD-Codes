function [Dictionary_string] = Monomial_dictionary_display(Dictionary)
%MONOMIAL_DICTIONARY_DISPLAY Converts a monomial dictionary matrix to string representation
%   This function takes a matrix representing powers of monomials and converts
%   it to a human-readable string format.
%
% Inputs:
%   Dictionary - An m×n matrix where each row represents a monomial term
%               and each column represents the power of the corresponding variable
%               Example: [1 0; 2 1] represents x_1^1 and x_1^2 * x_2^1
%
% Outputs:
%   Dictionary_string - A 1×m string array where each element contains the
%                      string representation of the corresponding monomial
%
% Example:
%   Dictionary = [1 0; 2 1];
%   result = Monomial_dictionary_display(Dictionary)
%   % Returns: ["x_1^1 x_2^0 ", "x_1^2 x_2^1 "]

% Create an array of variable names (x_1, x_2, etc.)
variables = [];
for ii = 1:size(Dictionary, 2)
    variables = [variables, (("x_" + int2str(ii)))];
end

% Initialize output string array with appropriate dimensions
Dictionary_string = strings(1, size(Dictionary, 1));

% Convert each monomial to string representation
for ii = 1:size(Dictionary, 1)
    for jj = 1:size(Dictionary, 2)
        % Build each term as: variable_name^power
        Dictionary_string(ii) = Dictionary_string(ii) + variables(jj) + ...
            "^" + int2str(Dictionary(ii,jj)) + " ";
    end
end
end

