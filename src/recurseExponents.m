function combinations = recurseExponents(numVariables, remainingDegree, currentCombination, combinations)
    % Recursively generates combinations of exponents.
    %
    % This is a helper function that is called recursively to build up
    % combinations of exponents that sum up to the maximum degree allowed.
    
    if length(currentCombination) == numVariables
        % Once a full combination is formed, add it to the combinations matrix.
        combinations(end+1, :) = currentCombination;
        return;
    end
    
    % Calculate the maximum value the next exponent can take.
    maxNextExponent = remainingDegree - sum(currentCombination);
    
    for nextExponent = 0:maxNextExponent
        newCombination = [currentCombination, nextExponent];
        % Recurse with the updated combination and reduced remaining degree.
        combinations = recurseExponents(numVariables, remainingDegree, newCombination, combinations);
    end
end