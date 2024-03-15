%% Path
clear
mainPath        = '/media/rajat/Rasendisk/lab/PhD/cogFlex/pilotBehavior/';
filePath        = struct2table(dir(fullfile(mainPath, "*mono*", "*.mat*")));
files           = strcat(filePath.folder, '/', filePath.name);

%% loadding files
meanRepeat          = [];
stDevRepeat         = [];
meanSwitch          = [];
stDevSwitch         = [];
h                   = [];
p                   = [];
ci                  = [];
stat                = [];
means               = [];
stds                = [];
handSwitchMean      = [];
fingerSwitchMean    = [];
noSwitchMean        = [];
handSwitchSD        = [];
fingerSwitchSD      = [];
noSwitchSD          = [];
meanMotorSwitching  = [];
stdMotorSwitchng    = [];

for iFiles = 1:length(files)
    
    load(files{iFiles})
    fullData                = struct2table(data2);
    fullData                = fullData(contains(fullData.Answer, 'Correct'),:);
    switchInd               = find(diff(fullData.TrialRule) ~= 0) + 1; % diff(array) calculates the difference between consecutive elements
    repeatInd               = setdiff(1:numel(fullData.TrialNo), switchInd);  
    noSwitchInd             = find(fullData.MotorSwitch == 0);
    fingerSwitchInd         = find(fullData.MotorSwitch == 1);
    handSwitchInd           = find(fullData.MotorSwitch == 2);
    
    % motor switching
    % noSwitchMean(end+1)         = mean(fullData.ReactionTime(noSwitchInd));
    % fingerSwitchMean(end+1)     = mean(fullData.ReactionTime(fingerSwitchInd));
    % handSwitchMean(end+1)       = mean(fullData.ReactionTime(handSwitchInd));
    % 
    % noSwitchSD(end+1)           = std(fullData.ReactionTime(noSwitchInd));
    % fingerSwitchSD(end+1)       = std(fullData.ReactionTime(fingerSwitchInd));
    % handSwitchSD(end+1)         = std(fullData.ReactionTime(handSwitchInd));
    % 
    % meanMotorSwitching(end+1,:)   = [noSwitchMean(end)  fingerSwitchMean(end) handSwitchMean(end)];
    % stdMotorSwitchng(end +1,:)    = [noSwitchSD(end)  fingerSwitchSD(end) handSwitchSD(end)];

    % switch vs repeat
    meanRepeat(end+1)       = mean(fullData.ReactionTime(repeatInd));
    meanSwitch(end+1)       = mean(fullData.ReactionTime(switchInd));
    stDevRepeat(end+1)      = std(fullData.ReactionTime(repeatInd));
    stDevSwitch(end+1)      = std(fullData.ReactionTime(switchInd));
    means(end+1,:)          = [meanRepeat(end) meanSwitch(end)];
    stds(end+1,:)           = [stDevRepeat(end) stDevSwitch(end)];
end

% Create subplots to display bar graphs side by side
n = length(files);
% n = 1;
figure;
for iPlot = 1:n
    subplot(1, n, iPlot);
    
    % x = [1 2 3]; % Category labels for repeat and switch conditions
    % y = meanMotorSwitching(iPlot,:);
    % err = stdMotorSwitchng(iPlot,:);
    
    x = [1 2];
    y = means(iPlot,:);
    err = stds(iPlot,:);


    bar(x, y);
    hold on;
    errorbar(x, y, err, 'linestyle', 'none', 'marker', 'o');
    % xticklabels({'noSwitch', 'fingerSwitch', 'handSwitch'})
    xticklabels({'noSwitch', 'handSwitch'})
    ylabel('Reaction time (s)')
    ylim([0 3])
    xlabel(sprintf('Subject 0%d',iPlot))
end
% title(strcat('Data from file: ', files{iPlot})); % Add a title for each plot
% legend('Mean', 'Standard Deviation', 'Location', 'bestoutside');
% ... (Rest of your code up to the for loop) ...
% ... (Rest of your code up to the for loop) ...
% ... (Rest of your code up to the for loop) ...





