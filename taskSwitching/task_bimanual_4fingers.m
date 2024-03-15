sca     % closes all screens
clear
cd '/media/rajat/Rasendisk/lab/matlabScrips/cogFlex/Functions'
input("start>>>     ", 's');
answer = inputdlg({'ID:', 'Prac:'}, 'Subject_ID', [1, 35; 1, 35], {'', ''});
try
    %% Setting up trials
    % Variables
    totalTrials     = 100;
    practiceTrials  = 10; % Each for number, letter and combined
    oddChoose       = [1 3 7 9];
    evenChoose      = [2 4 6 8];
    numChoose       = [1 2 3 4 6 7 8 9];
    letterChoose    = ['A', 'E', 'I', 'U','G', 'M', 'R', 'K'];
    oddChooseTest   = ['1' '3' '7' '9'];
    evenChooseTest  = ['2' '4' '6' '8'];
    vowelChoose     = ['A', 'E', 'I', 'U'];
    consonantChoose = ['G', 'M', 'R', 'K'];

    %Trial Randomization and sequencing
    non_targetTrials    = zeros(1,length(totalTrials));
    target_Trials       = zeros(1,length(totalTrials));
    for i = 1:2
        % input arrayss
        letterTrials      = genSeq(letterChoose, totalTrials);
        numTrials          = genSeq(numChoose, totalTrials);
              
      
        % Trials
        trials          = vertcat(letterTrials, numTrials)';
        trials          = strcat(trials(:,1), trials(:,2));
        
        % swaping position of letter and numbers for half of the trials
        randomNumbers = randperm(totalTrials, totalTrials/2);
        for ee = randomNumbers
            pos1            = trials{ee}(1);
            pos2            = trials{ee}(2);
            
            trials{ee}(1)   = pos2;
            trials{ee}(2)   = pos1;
        end
               
        if i == 1
            target_Trials = trials;
        else
            non_targetTrials = trials;
        end
        
    end
    
    % trial rule: Target position
    taskRule   = generateRandomArray([1 2], totalTrials);
    % non-task rule
    nonTaskRule = zeros(1,length(taskRule));
    for i = 1:length(taskRule)
        if taskRule(i) == 1
            nonTaskRule(i)    = 2;
        else 
            nonTaskRule(i)  = 1;
        end
    end

    %% Call defaults
    PsychDefaultSetup(1) % executes the AssertOpenGL cmd and KbName('UnifyKeyNames')
    % Screen('Preference', 'SkipSyncTests', 1); % Comment during the main experiment
    % IF 0 Do not skip the sync test, 1 &amp; 2 skip the test (different settings)
    % Setup Screens
    screens = Screen('Screens');
    numberOfScreens = max(screens); % Gets the screen number, typically, 0 = primary; 1 = external screen
    chosenScreen = numberOfScreens; % Choose which screen to display on (here, external screen is selected)
    rect = []; % Full screen
    % Get the luminiscence value
    white   = WhiteIndex(chosenScreen); % 255
    black   = BlackIndex(chosenScreen); % 0
    grey    =  white/2;
    red     = [255 0 0];
    green   = [0 255 0];
    yellow  = [255 255 0];
    % Open PTB
    [w, scr_rect] = PsychImaging('OpenWindow', chosenScreen, black, rect); % scr_rect gives the size of the screen
    % Priority(MaxPriority(w));
    % Priority(0);
    [centerX, centerY] = RectCenter(scr_rect); % get coordinates of the center of the screen
    HideCursor(w);
    % Get flip and refresh rates
    ifi = Screen('GetFlipInterval', w); % interframe Interval
    hertz = FrameRate(w);
    %% Define response options
    R_leftKey     = KbName('.>');
    R_rightKey    = KbName('/?');
    L_leftKey     = KbName('z');
    L_rightKey    = KbName('x');
    escapeKey   = KbName('ESCAPE');
    startKey    = KbName('LeftShift');
    endKey      = KbName('RightShift');
    while KbCheck; end % Slow for the first time, therefore called here
    %% Draw
    % Define crosshair parameters
    crossLength     = 7;
    crossWidth      = 2;
    crossColor      = white*3/4;
    FlushEvents; % if any key is pressed before this event it clears all
    stimPosition    = [25 -83];
    waitFrames      = 1;
    numFrames       = round(waitFrames / ifi);
    numFrames       = round(waitFrames / ifi);
    %% Table
    % Define column names
    % columnNames = {'Trial No', 'Trial rule','Target Stimulus', 'Non-Target stimulus', 'Stimulus name' ...
    %     'Stimulus onset', 'Key pressed','Response time', 'Answer', 'Reaction time'};
    % Instructions
    % Define instructions
    instructions1 = {
        'Number-Letter Switching Task'
        ''
        'Welcome!'
        ''
        ''
        'Task Overview:'
        ''
        'You''ll see two letter-number pairs (e.g. 1E, V9). The brighter pair is the TARGET'
        ''
        'You need to report about the letter / number in the target'
        'Position of the target relative to ''+'' determines whether to report letter / number.'
        ''
        '- Focus on the crosshair.'
        'Be as fast and accurate you can be'
        'We will start with some practice trials'
        ''
        'Ready'
        'Press "Left-shift" to start.'
        };
    % Odd / Even
    instructions2 = {
        'Let''s first train for the NUMBERS.'
        ''
        'Use key ''>'' to report an ODD number'
        ''
        'Use key ''?'' to report an EVEN number'
        ''
        ''
        'Press ''Left Shift'' to begin'
        };
    % Consonant / vowel
    instructions3 = {
        'Let''s now train for the LETTERS.'
        ''
        'Use key ''Z'' to report a Consonant'
        ''
        'Use key ''X'' to report an Vowel'
        ''
        ''
        'Press ''Left Shift'' to begin'
        };
    instructions4 = {
        'Let''s now train for both NUMBERS & LETTERS.'
        ''
        'Task rule 1: When target appears ABOVE the ''+'''
        'Use key ''>'' to report an ODD number'
        'Use key ''?'' to report an EVEN number'
        ''
        ''
        'Task rule 2: When target appears BELOW the ''+'''
        'Use key ''Z'' to report a Consonant'
        'Use key ''X'' to report an Vowel'
        ''
        ''
        'Press ''Left Shift'' to begin'
        };
    % Convert cell array to a single string with newline characters
    instructionsText = sprintf('%s\n', instructions1{:});
    %% Looping
    stimulusOnsetTime = [];
    responseTime      = [];
    reactionTime      = [];
    targettttt        = [];
    vbl = Screen('Flip', w); % baseline sync
    %% Practice trials
    if strcmp(answer(2), '1')
        while true
            Screen('TextSize', w, 30); % set text size to the fixation length
            Screen('TextFont', w, 'Arial');
            DrawFormattedText(w, instructionsText, 'center', 'center', white);
            vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
            [secs, keyCode, deltaSecs] = KbWait([], 2);

            if keyCode(escapeKey)
                break

            elseif keyCode(startKey)
                WaitSecs(0.1)

                for iRule = 1:3
                    FlushEvents
                    if iRule == 1
                        instructionsText = sprintf('%s\n', instructions2{:});
                    elseif iRule == 2
                        instructionsText = sprintf('%s\n', instructions3{:});
                    elseif iRule == 3
                        xx = 1;
                        instructionsText = sprintf('%s\n', instructions4{:});
                    end
                    Screen('TextSize', w, 30); % set text size to the fixation length
                    Screen('TextFont', w, 'Arial');
                    DrawFormattedText(w, instructionsText, 'center', 'center', white);
                    vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                    [secs, keyCode, deltaSecs] = KbWait([], 2);
                    [keyIsDown, secs, keyCode]  = KbCheck;

                    if keyIsDown
                        if keyCode(escapeKey)
                            break
                        elseif keyCode(startKey)
                            % Present cross-hair for 1 sec
                            for iTime = 1:numFrames
                                Screen('DrawLines', w, [-crossLength, crossLength, 0, 0; 0, 0, -crossLength, crossLength],...
                                    crossWidth, crossColor, [centerX, centerY]);
                                vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                            end

                            % Looping through trials
                            for iTrial = 1:practiceTrials
                                tempRule    = iRule;
                                WaitSecs(0.2);
                                if iRule == 1
                                    targetTrial                 = numTrials{iTrial};
                                    Screen('DrawLines', w, [-crossLength, crossLength, 0, 0; 0, 0, -crossLength, crossLength],...
                                    crossWidth, crossColor, [centerX, centerY]);
                                    % target
                                    Screen('TextSize', w, 80); % set text size to the fixation length
                                    Screen('TextFont', w, 'Noto Sans Mono');

                                    DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), white);
                                    % stimulus presentation
                                    vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                    stimulusOnsetTime(end+1) = vbl;

                                elseif iRule == 2
                                    targetTrial                 = letterTrials{iTrial};
                                    Screen('DrawLines', w, [-crossLength, crossLength, 0, 0; 0, 0, -crossLength, crossLength],...
                                    crossWidth, crossColor, [centerX, centerY]);
                                    % target
                                    Screen('TextSize', w, 80); % set text size to the fixation length
                                    Screen('TextFont', w, 'Noto Sans Mono');

                                    DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), white);
                                    vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                    stimulusOnsetTime(end+1) = vbl;

                                elseif iRule == 3
                                    targetTrial                 = target_Trials{iTrial};
                                    if iTrial >= practiceTrials/2
                                        iRule = 1;
                                        Screen('DrawLines', w, [-crossLength, crossLength, 0, 0; 0, 0, -crossLength, crossLength],...
                                            crossWidth, crossColor, [centerX, centerY]);
                                        % target
                                        Screen('TextSize', w, 80); % set text size to the fixation length
                                        Screen('TextFont', w, 'Noto Sans Mono');

                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(1), white);
                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                        stimulusOnsetTime(end+1) = vbl;
                                    else
                                        iRule = 2;
                                        Screen('DrawLines', w, [-crossLength, crossLength, 0, 0; 0, 0, -crossLength, crossLength],...
                                        crossWidth, crossColor, [centerX, centerY]);
                                        % target
                                        Screen('TextSize', w, 80); % set text size to the fixation length
                                        Screen('TextFont', w, 'Noto Sans Mono');

                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(2), white);
                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                        stimulusOnsetTime(end+1) = vbl;

                                    end
                                end
                                targettttt{end+1}               = targetTrial;
                                
                                response = false;
                                while ~response
                                    [keyIsDown, secs, keyCode]  = KbCheck;
                                    if keyIsDown()
                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                        responseTime(end+1)     = vbl;
                                        reactionTime(end+1)     = responseTime(end) - stimulusOnsetTime(end);
                                        response = true;

                                        if keyCode(escapeKey) % TO QUIT
                                            break

                                        
                                        elseif iRule == 1 % ODD / EVEN
                                            if keyCode(R_leftKey)
                                               if any(ismember(targetTrial, oddChooseTest))
                                                   if reactionTime(end) >= 1.2 % correct and slow
                                                        for iTime = 1:numFrames
                                                            DrawFormattedText(w, 'FASTER', 'center', centerY-280, yellow);
                                                            DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), green);
                                                            vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                        end
                                                   else
                                                       for iTime = 1:numFrames % correct
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), green);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                       end
                                                   end
                                               else
                                                   for iTime = 1:numFrames % wrong
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), red);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                   end

                                               end
                                            elseif keyCode(R_rightKey)
                                               if any(ismember(targetTrial, evenChooseTest))
                                                   if reactionTime(end) >= 1.2 % correct and slow
                                                        for iTime = 1:numFrames
                                                            DrawFormattedText(w, 'FASTER', 'center', centerY-280, yellow);
                                                            DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), green);
                                                            vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                        end
                                                   else
                                                       for iTime = 1:numFrames % correct
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), green);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                       end
                                                   end
                                               else
                                                   for iTime = 1:numFrames % wrong
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), red);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                   end

                                               end
                                            else
                                                for iTime = 1:numFrames % wrong
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), red);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                               end
                                            end
                                        elseif iRule == 2
                                            if keyCode(L_leftKey)
                                               if any(ismember(targetTrial, consonantChoose))
                                                   if reactionTime(end) >= 1.2 % correct and slow
                                                        for iTime = 1:numFrames
                                                            DrawFormattedText(w, 'FASTER', 'center', centerY-280, yellow);
                                                            DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), green);
                                                            vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                        end
                                                   else
                                                       for iTime = 1:numFrames % correct
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), green);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                       end
                                                   end
                                               else
                                                   for iTime = 1:numFrames % wrong
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), red);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                   end

                                               end
                                            elseif keyCode(L_rightKey)
                                               if any(ismember(targetTrial, vowelChoose))
                                                   if reactionTime(end) >= 1.2 % correct and slow
                                                        for iTime = 1:numFrames
                                                            DrawFormattedText(w, 'FASTER', 'center', centerY-280, yellow);
                                                            DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), green);
                                                            vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                        end
                                                   else
                                                       for iTime = 1:numFrames % correct
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), green);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                       end
                                                   end
                                               else
                                                   for iTime = 1:numFrames % wrong
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), red);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                                   end

                                               end
                                           else
                                                for iTime = 1:numFrames % wrong
                                                        DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(iRule), red);
                                                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                                               end
                                            end                                     
                                        end
                                    end
                                end
                                iRule = tempRule;
                            end
                        end
                    end
                end
            end
            break
        end
    end
    %% Experiment trial
    instructionsText = sprintf('%s\n', instructions1{:});
    % Preallocate arrays to store timing information
    stimulusOnsetTime       = [];
    responseTime            = [];
    stimulusName            = [];
    keyPressed              = [];
    reactionTime            = [];
    RESPONSE                = [];
    rule                    = [];
    trialNo                 = [];
    targett_trial           = [];
    non_targett_trial       = [];
    motorSwitch             = [];
    targetType              = [];
    vbl = Screen('Flip', w); % baseline sync
    % RESPONSE = zeros(1,totalTrials);
    while true
        % Instructions
        Screen('TextSize', w, 30); % set text size to the fixation length
        Screen('TextFont', w, 'Arial');
        DrawFormattedText(w, instructionsText, 'center', 'center', white);
        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(startKey)
                responseTime(end+1)         = secs;
                stimulusName{end+1}         = "Instructions";
                stimulusOnsetTime(end+1)    = vbl;
                keyPressed{end+1}           = KbName(find(keyCode));
                RESPONSE{end+1}             = 'START';
                rule(end+1)                 = 0;
                trialNo(end+1)              = 0;
                reactionTime(end+1)         = 0;
                targett_trial{end+1}        = '-';
                non_targett_trial{end+1}    = '-';
                motorSwitch(end+1)          = 0;
                targetType{end+1}           = '-';
            end
        end
        if keyCode(escapeKey)
            break
        elseif keyCode(startKey)
            % cross-hair for 1 sec
            for iTime = 1:numFrames
                Screen('DrawLines', w, [-crossLength, crossLength, 0, 0; 0, 0, -crossLength, crossLength],...
                    crossWidth, crossColor, [centerX, centerY]);
                if iTime == 1
                    vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                end
            end
            for iTrial = 1: totalTrials % loop through the total trials
                WaitSecs(0.25);
                trialRule                   = taskRule(iTrial);
                nonTrialRule                = nonTaskRule(iTrial);
                targetTrial                 = target_Trials{iTrial};
                nonTargetTrial              = non_targetTrials{iTrial};
                targett_trial{end+1}        = target_Trials{iTrial};
                non_targett_trial{end+1}    = non_targetTrials{iTrial};
                Screen('DrawLines', w, [-crossLength, crossLength, 0, 0; 0, 0, -crossLength, crossLength],...
                    crossWidth, crossColor, [centerX, centerY]);
                % target
                Screen('TextSize', w, 80); % set text size to the fixation length
                Screen('TextFont', w, 'Noto Sans Mono');
                DrawFormattedText(w, targetTrial, 'center', centerY-stimPosition(trialRule), white);
                % non-target
                Screen('TextSize', w, 80); % set text size to the fixation length
                Screen('TextFont', w, 'Noto Sans Mono');
                DrawFormattedText(w, nonTargetTrial, 'center', centerY-stimPosition(nonTrialRule), grey);
                vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                % [keyIsDown, secs, keyCode] = KbCheck;
                stimulusName{end+1} = strcat(targetTrial, "_",nonTargetTrial);
                stimulusOnsetTime(end+1) = vbl;
                rule(end+1)                 = taskRule(iTrial);
                trialNo(end+1)              = iTrial;
                % exit
                if keyCode(escapeKey)
                    response = true;
                    break;
                end
                response = false;
                while ~response
                    [keyIsDown, secs, keyCode] = KbCheck;
                    % responseTime(end+1) = secs;
                    if keyIsDown
                        vbl = Screen('Flip', w, vbl+(waitFrames-0.5)*ifi);
                        keyPressed{end+1}       = KbName(find(keyCode));
                        responseTime(end+1)     = vbl;
                        if keyCode(escapeKey)
                            response = true;
                            break; % Exit loop if escape key is pressed
                        elseif trialRule == 1
                            if any(ismember(targetTrial, oddChooseTest))
                                targetType{end+1} = 'Odd';
                            else
                                targetType{end+1} = 'Even';
                            end
                            if keyCode(R_leftKey)
                                response = true;
                                if any(ismember(targetTrial, oddChooseTest))
                                    RESPONSE{end+1} = 'Correct';
                                else
                                    RESPONSE{end+1} = 'Incorrect';
                                end
                            elseif keyCode(R_rightKey)
                                response = true;
                                if any(ismember(targetTrial, evenChooseTest))
                                    RESPONSE{end+1} = 'Correct';
                                else
                                    RESPONSE{end+1} = 'Incorrect';
                                end
                            else
                                RESPONSE{end+1} = 'Incorrect';
                                break
                            end
                        elseif trialRule == 2
                            if any(ismember(targetTrial, consonantChoose))
                                targetType{end+1} = 'Consonant';
                            else
                                targetType{end+1} = 'Vowel';
                            end
                            if keyCode(L_leftKey)
                                response = true;
                                if any(ismember(targetTrial, consonantChoose))
                                    RESPONSE{end+1} = 'Correct';
                                else
                                    RESPONSE{end+1} = 'Incorrect';
                                end
                            elseif keyCode(L_rightKey)
                                response = true;
                                if any(ismember(targetTrial, vowelChoose))
                                    RESPONSE{end+1} = 'Correct';
                                else
                                    RESPONSE{end+1} = 'Incorrect';
                                end
                            else
                                RESPONSE{end+1} = 'Incorrect';
                                break
                            end
                        end
                    end
                end
                if iTrial == 1
                    motorSwitch(end+1)  = 0;
                elseif rule(end) ~= rule(end-1)
                    motorSwitch(end+1)  = 2;
                elseif ~strcmp(keyPressed(end), keyPressed(end-1)) && rule(end) == rule(end-1)
                    motorSwitch(end+1)  = 1;
                else
                    motorSwitch(end+1)  = 0;
                end
                reactionTime(end+1)     = responseTime(end) - stimulusOnsetTime(end);
            end
            Screen('TextSize', w, 100);
            DrawFormattedText(w, 'Thank you', 'center', 'center', white);
            Screen('Flip', w); % baseline syncing
            KbWait([], 2);
            break
        end
    end
    sca;

    %% Logging responses
    data = table();
    columnNames = {'TrialNo', 'TrialRule', 'TargetStimulus', 'NonTargetStimulus', 'StimulusName', 'TagetType'...
        'StimulusOnset', 'KeyPressed', 'ResponseTime', 'MotorSwitch', 'Answer', 'ReactionTime'};
    variableName = {trialNo', rule', targett_trial',  non_targett_trial', stimulusName', targetType', stimulusOnsetTime', ...
        keyPressed', responseTime', motorSwitch', RESPONSE', reactionTime'};
    for ii = 1:length(columnNames)
        field = columnNames{ii};
        data.(field) = variableName{ii};
    end
    data2 = table2struct(data); 
    % saving files
    cd '/media/rajat/Rasendisk/lab/PhD/cogFlex/pilotBehavior/'
    fileName    = strcat('cogFlex_', answer{1}, '_0', answer{2});
    fileName2    = strcat('cogFlex_', answer{1}, '_0', answer{2}, '.mat');
    mkdir(answer{1})
    cd(answer{1})
    writetable(data, fileName)
    save(fileName2, 'data2')
catch
    sca; % close all screens
    ShowCursor; % shows the mouse cursor
    psychrethrow(psychlasterror); % prints the last error message to the cmd window
end