% Reset variables to ensure a clean re-run
clear; 
clc; 

filename = '/Users/ansle/Documents/GitHub/trial_and_error/data/Simultaneity1/201_Day1_SJTraining_Clean.xlsx'; 
data = readtable(filename);

% Select the first column (assuming it's named, e.g., 'SOAs')
SOAs = data{:, 1}; % Extract the first column as an array

% Initialize numeric output array
numeric_data = zeros(height(data), 1); 

% Iterate through each entry in the data
for i = 1:height(data)
    entry = SOAs{i}; % Access each entry
    if endsWith(entry, 'AV') % Negative values for 'AV'
        numeric_data(i) = -str2double(entry(4:end-2));
    elseif endsWith(entry, 'VA') % Positive values for 'VA'
        numeric_data(i) = str2double(entry(4:end-2));
    elseif strcmp(entry, 'Sync') % Zero for 'Sync'
        numeric_data(i) = 0;
    end
end

% Ensure numeric_data is a column vector
numeric_data = numeric_data(:); % Reshape to ensure it's a column

% Create a copy of the original table
data2 = data;
data2.(data.Properties.VariableNames{1}) = numeric_data;

stimulus = data2.CRESP; % Extract 'CRESP'
SNR = data2.Procedure_Trial_; % Extract 'Procedure_Trial_'
response = data2.RESP; % Extract 'RESP'
RT = data2.RT; % Extract 'RT'

% Create a new array with the specified column order
rawData = [stimulus, SNR, response, RT];

processedData = preprocessData(rawData);
disp(processedData);
visualizeDescriptiveAnalysis(processedData);

% Test Function
fitBayesianModel(processedData);
