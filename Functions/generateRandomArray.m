function output_array = generateRandomArray(input_array, output_length)
    output_array = []; % Initialize the output array
    num_reps = randi([2, 4]); % Generate random repetitions between 2 and 4
    
    while length(output_array) < output_length
        % Repeat each element of the input array according to the random repetitions
        for i = 1:length(input_array)
            output_array = [output_array repmat(input_array(i), 1, num_reps)];
            if length(output_array) >= output_length
                break; % If the desired length is reached, exit the loop
            end
        end
        num_reps = randi([2, 4]); % Update the number of repetitions for the next iteration
    end
    
   output_array = output_array(1:output_length); % Trim the output array if its length exceeds the desired length
end