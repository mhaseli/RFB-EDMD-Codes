function [eigenfunction_string] = Eigenfunction_display(Dictionary, eigenvector)
%EIGENFUNCTION_DISPLAY Creates string representation of an eigenfunction
%   This function generates a human-readable string representation of an
%   eigenfunction by combining a monomial dictionary with its corresponding
%   eigenvector coefficients.
%
% Inputs:
%   Dictionary - An m×n matrix where each row represents a monomial term
%               and each column represents the power of the corresponding variable
%               Example: [1 0; 2 1] represents x_1^1 and x_1^2 * x_2^1
%   eigenvector - An m×1 vector containing the coefficients for each monomial
%                 term in the Dictionary
%
% Outputs:
%   eigenfunction_string - A string containing the complete eigenfunction
%                         representation, where each term is of the form:
%                         (coefficient) x_1^p1 x_2^p2 ...
%
% Example:
%   Dictionary = [1 0; 2 1];
%   eigenvector = [2; -1];
%   result = Eigenfunction_display(Dictionary, eigenvector)
%   % Returns: "(2) x_1^1 x_2^0 + (-1) x_1^2 x_2^1"
%
% See also: Monomial_dictionary_display

% Get the string representation of the monomial terms
eigenfunction_string = Monomial_dictionary_display(Dictionary);

% Add coefficients from the eigenvector to each term
for ii = 1:length(eigenfunction_string)
    % Format each term as: (coefficient) monomial
    eigenfunction_string(ii) = "(" + num2str(eigenvector(ii)) + ") " + eigenfunction_string(ii);
end

% Combine all terms with plus signs between them
eigenfunction_string = strjoin(eigenfunction_string, " + ");
end

