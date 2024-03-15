function taskSequence = generateTaskSequence(taskRule1, taskRule2, totalTrials)
    % Calculate the number of trials for each task rule
    trialsPerRule = totalTrials / 2;

    % Define the range of consecutive repeat trials before a switch
    minRepeat = 2;
    maxRepeat = 5;

    % Initialize the task sequence
    taskSequence = [];

    % Alternate between the two task rules
    for i = 1:totalTrials
        % Determine the current task rule
        if rem(i, 2) == 1
            currentTaskRule = taskRule1;
        else
            currentTaskRule = taskRule2;
        end

        % Add the current task rule to the sequence
        taskSequence = [taskSequence, currentTaskRule];

        % Generate a random number of consecutive repeat trials before a switch
        if i < totalTrials
            repeatTrials = randi([minRepeat, maxRepeat]);
            for j = 1:repeatTrials
                taskSequence = [taskSequence, currentTaskRule];
            end
            i = i + repeatTrials;
        end
    end

    % Randomize the order of the trials
    taskSequence = taskSequence(randperm(totalTrials));
end
