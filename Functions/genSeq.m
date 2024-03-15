function result = genSeq(setArray, numTrials)  
    % numChoose is the array for choosing
    % numTrials is the number of trials required
    % Convert numChoose to a cell array of strings

    if isnumeric(setArray)
        setArray = arrayfun(@num2str, setArray, 'UniformOutput', false);
    end
    
    % Generate a random permutation of numChoose
    permutedChoices = setArray(randperm(length(setArray)));

    % Select elements ensuring they are not consecutive
    result = cell(1, numTrials);
    result{1} = permutedChoices(1);

    for i = 2:numTrials
        previousIndex = find(strcmp(permutedChoices, result{i-1})); % 'find'- Finds the index of previous element
        availableChoices = permutedChoices(previousIndex + 1:end); % Exclude elements before previous
        if ~isempty(availableChoices)
            result{i} = availableChoices{1};
        else
            % If no available choices, start over with a new permutation
            permutedChoices = setArray(randperm(length(setArray)));
            result{i} = permutedChoices(1);
        end
    end
    for i = 2:numTrials
        while strcmp(result{i}, result{i-1})
            % If current element is same as previous, select a new element
            permutedChoices = setArray(randperm(length(setArray)));
            result{i} = permutedChoices(1);
        end
    end
    %%
    [row, col] = size(result);
    for i = 1:row
        for j = 1:col
            if iscell(result{i, j})
                result{i, j} = result{i, j}{1}; % Extract string from cell
            end
        end
    end
    result
end
