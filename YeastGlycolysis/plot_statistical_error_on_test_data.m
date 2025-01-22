
% This script generates and plots statistical error analysis for the RFB-EDMD  method
% applied to a yeast glycolysis system

% Clear workspace and figures
clear
close all
clc

% Add required paths and load saved data
addpath('../src/')  % Add path to source directory containing RFB-EDMD implementation
load('saved_data/trajectory_data.mat')  % Load training trajectory data
load('saved_data/RFB_EDMD_data.mat')   % Load trained RFB-EDMD model data

%% Dictionary Application
% Apply the dictionary transformation to the training data
% X contains the initial states, Y contains the final states
DX = dictionary(X);  % Transform initial states
DY = dictionary(Y);  % Transform final states

%% Directory Setup for Saving Figures
% Create a hierarchical directory structure for storing different figure formats

% Create main figures directory if it doesn't exist
figsDir = 'figures';
if ~exist(figsDir, 'dir')
    mkdir(figsDir);
end

% Create subdirectory for error-related figures
figRelativeDir = fullfile(figsDir, 'figError');
if ~exist(figRelativeDir, 'dir')
    mkdir(figRelativeDir);
end

% Create directory for PNG format figures
figuresDir = fullfile(figRelativeDir, 'figuresError');
if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

% Create directory for EPS format figures
figuresEpsDir = fullfile(figRelativeDir, 'figuresErroreps');
if ~exist(figuresEpsDir, 'dir')
    mkdir(figuresEpsDir);
end

%% Plot Formatting Settings
% Set default plotting parameters for consistent figure appearance
set(0, 'DefaultTextFontName', 'Times', ...
    'DefaultTextFontSize', 18 * 2, ...
    'DefaultAxesFontName', 'Times', ...
    'DefaultAxesFontSize', 18 * 2, ...
    'DefaultLineLineWidth', 1 * 2, ...
    'DefaultLineMarkerSize', 7.75 * 3);

%% Generate Test Data
% Create and evolve test points to evaluate model performance

% Initialize test parameters
test_num = 10000;    % Number of test points
rng(123);            % Set random seed for reproducibility
testPoints = rand(test_num,7);  % Generate random test points in 7D space

% Initialize matrix for evolved points
finalPoints = zeros(size(testPoints));

% Set ODE solver options for accurate simulation
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);

% Evolve each test point through the true system dynamics
for i = 1:size(testPoints, 1)
    y0 = testPoints(i, :);  % Get initial condition
    % Simulate system using ODE45 solver
    [t, ysim] = ode45(@(t, y) yeastGlycolysisEq(t, y, params), [0 sampleTime], y0, opts);
    finalPoints(i, :) = ysim(end, :);  % Store final state
end

%% Error Analysis and Visualization
% Generate error histograms for different epsilon values

for ii = 1:length(epsilon_values)
% choosing the output for the appropriate subspace
C = rfb_C_cell{ii};

% applying EDMD on the new subspace using the original data
K = (DX*C)\(DY*C);

% defining dictionary_pruned as a function handle (this handle takes
% dataMatrix as input, applies the dictionary, and multiplies by C)
dictionary_pruned = @(point) dictionary(point) * C;

% defining the normalized error function
normalized_dictionary_error = @(initialpoint,finalpoint) (vecnorm(dictionary_pruned(finalpoint) - dictionary_pruned(initialpoint)*K,2,2) ./ vecnorm(dictionary_pruned(finalpoint),2,2) )*100;

% applying the normalized error function on the grid
dictionaryErrorTest = normalized_dictionary_error(testPoints,finalPoints);

%  Ploting the Error of Dictionary Prediction over the Domain
figDictionaryError = figure;
set(figDictionaryError, 'Position', [100, 100, 800, 600]);
histogram(dictionaryErrorTest,'BinEdges',0:2:200,'Normalization','percentage')
xlabel('$E_{rel}(\%)$','Interpreter', 'latex');
ylabel('Points per Bin (\%)','Interpreter', 'latex');
xlim([0,200])
% Save the figure in PNG and EPS
saveas(figDictionaryError, fullfile(figuresDir, ['Error_YeastGlycolysis_FBEDMD_eps_1e-4_times_' num2str(epsilon_values(ii)*10000) '.png']));
print(figDictionaryError, fullfile(figuresEpsDir, ['Error_YeastGlycolysis_FBEDMD_eps_1e-4_times_' num2str(epsilon_values(ii)*10000)]), '-depsc');

end
