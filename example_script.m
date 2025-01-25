%% Sample Script
close all; clear; clc;

load('data/Motion2/Motion2_VisOnly.mat')
rawData = data_output;

processedData = preprocessData(rawData);
processedData = processedData(processedData.Stimulus ~= 0, :);
processedData = processedData(~isnan(processedData.RT), :);

% Make descriptive plots
visualizeDescriptiveAnalysis(processedData);

% Make DDM plots
DDM_SNR(processedData);

% Initialize the drift variable
numTrials = height(processedData);
drift = zeros(1, numTrials); % Initialize drift state
initial_state = 0; % Start drift at zero
drift(1) = initial_state;

% Normalize Response for drift calculations
normalizedResponse = processedData.Response; % Copy original response
normalizedResponse(normalizedResponse == 2) = -1; % Right -> -1 (toward bottom boundary)
normalizedResponse(normalizedResponse == 1) = 1;  % Left -> +1 (toward top boundary)

% Loop through trials and calculate drift
for t = 2:numTrials
    if ~isnan(normalizedResponse(t)) && ~isnan(processedData.PrevOutcome(t))
        if processedData.PrevOutcome(t) == 1 % Correct
            drift(t) = drift(t-1) + normalizedResponse(t); % Positive drift
        elseif processedData.PrevOutcome(t) == 0 % Incorrect
            drift(t) = drift(t-1) - normalizedResponse(t); % Negative drift
        end
    else
        drift(t) = drift(t-1); % No change if PrevOutcome or Response is NaN
    end
end

verifyRTDriftCorrelation(processedData, drift);


%averageDriftState = mean(drift);
%disp(['Average Drift State: ', num2str(averageDriftState)]);

% Example Data
%data.SNR = rand(100, 1); % Random SNR values
%data.Response = rand(100, 1) < 0.5 + 0.3 * data.SNR; % Synthetic responses

% Test Function
%fitBayesianModel(data);
