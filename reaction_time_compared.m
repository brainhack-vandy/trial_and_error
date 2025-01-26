%% Compare Reaction Times for Different Cues
close all; clear; clc;

% Specify the file names for different cues
files = {"Motion1_AV_cueA.mat", "Motion1_AV_cueV.mat", "Motion1_AV_cueAV.mat"};
labels = {"Cue A", "Cue V", "Cue AV"};
colors = {'r', 'g', 'b'};

% Initialize storage for reaction times
allRTs = cell(1, length(files));

% Loop through each file and process the data
for i = 1:length(files)
    fileName = files{i};
    load(fileName);
    rawData = data_output;

    % Determine modality
    if contains(fileName, '_cueA')
        mod = "A";
    elseif contains(fileName, '_cueV')
        mod = "V";
    elseif contains(fileName, '_cueAV')
        mod = "AV";
    else
        error('Unknown modality in file name: %s', fileName);
    end

    % Preprocess the data
    processedData = preprocessAVdata(rawData, mod);

    % Filter out invalid reaction times
    validRTs = processedData.RT(~isnan(processedData.RT));
    allRTs{i} = validRTs;
end

% Plot reaction times
figure;
hold on;
for i = 1:length(files)
    % Create a boxplot for each cue
    boxchart(ones(size(allRTs{i})) * i, allRTs{i}, 'BoxFaceColor', colors{i});
end

% Customize the plot
xticks(1:length(files));
xticklabels(labels);
xlabel('Cue Type');
ylabel('Reaction Time (ms)');
title('Comparison of Reaction Times for Different Cues');
grid on;
hold off;
