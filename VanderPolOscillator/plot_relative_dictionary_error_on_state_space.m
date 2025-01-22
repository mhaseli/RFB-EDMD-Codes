%%% Relative Prediction Error Analysis Script
% This script visualizes the relative prediction error of the RFB-EDMD model across the state space. It computes and plots the normalized dictionary prediction error for different epsilon values.

%% Initialize Environment and Load Data
clear
close all
clc
% Add path to source directory containing RFB-EDMD implementation and utility functions
addpath('../src/')
% Load necessary data files
load('saved_data/RFB_EDMD_data.mat');  % Contains trained RFB-EDMD results
load('saved_data/trajectory_data.mat');          % Contains the trajectory data

% Apply the dictionary to the state matrices
DX = dictionary(X);
DY = dictionary(Y);

%% Configure Directory Structure and Plot Settings
% Create directory hierarchy for saving figures
% Main figures directory
figsDir = 'figures';
if ~exist(figsDir, 'dir')
    mkdir(figsDir);
end

% Subdirectory for relative error plots
figRelativeDir = fullfile(figsDir, 'figRelative');
if ~exist(figRelativeDir, 'dir')
    mkdir(figRelativeDir);
end

% Directory for PNG format
figuresDir = fullfile(figRelativeDir, 'figuresRelative');
if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

% Directory for EPS format
figuresEpsDir = fullfile(figRelativeDir, 'figuresRelativeeps');
if ~exist(figuresEpsDir, 'dir')
    mkdir(figuresEpsDir);
end

%% Set global visualization parameters for consistent plotting
set(0, 'DefaultTextFontName', 'Times', ...
    'DefaultTextFontSize', 18 * 2, ...
    'DefaultAxesFontName', 'Times', ...
    'DefaultAxesFontSize', 18 * 2, ...
    'DefaultLineLineWidth', 1 * 2, ...
    'DefaultLineMarkerSize', 7.75 * 3);

%% Generate State Space Grid 
% Define domain boundaries and resolution
xMin = -3; xMax = 3;
yMin = -3; yMax = 3;
stepSize = 0.05; % Resolution of the grid

% Create 2D grid for visualization
[x, y] = meshgrid(xMin:stepSize:xMax, yMin:stepSize:yMax);
gridPoints = [x(:), y(:)]; % Flatten grid to point list

%% Simulate system evolution for one time step from each grid point
% Initialize matrix to store final points
finalPoints = zeros(size(gridPoints));

% Compute the evolution of each initial condition
for i = 1:size(gridPoints, 1)
    y0 = gridPoints(i, :);
    [t, ysim] = ode45(vanderPolEq, [0 sampleTime], y0);
    finalPoints(i, :) = ysim(end, :);
end

%% Compute and Visualize Relative Error for Different Epsilon Values
for ii = 1:length(epsilon_values)
    % Select appropriate subspace projection matrix
    C = rfb_C_cell{ii};
    
    % Compute EDMD operator for the projected subspace
    K = (DX*C)\(DY*C);

    % Define identified dictionary function by RFB-EDMD
    dictionary_pruned = @(point) dictionary(point) * C;
    
    % Define normalized error function (as percentage)
    normalized_dictionary_error = @(initialpoint,finalpoint) (vecnorm(dictionary_pruned(finalpoint) - dictionary_pruned(initialpoint)*K,2,2) ./ vecnorm(dictionary_pruned(finalpoint),2,2) )*100;
    
    % Compute error across the grid
    dictionaryErrorGrid = normalized_dictionary_error(gridPoints,finalPoints);
    Z = reshape(dictionaryErrorGrid, size(x)); % Reshape to 2D grid
    
    % Create and configure error visualization
    figDictionaryError = figure;
    set(figDictionaryError, 'Position', [100, 100, 800, 800]);
    surf(x, y, Z, 'EdgeColor', 'none');
    hColorbar = colorbar;
    colormap('jet')
    clim([0 20]); % Limit color scale to 0-10%
    ylabel(hColorbar, '\%', 'Interpreter', 'latex');
    xlabel('$x_1$', 'Interpreter', 'latex');
    ylabel('$x_2$', 'Interpreter', 'latex');
    view(0, 90);
    axis([xMin xMax yMin yMax]);
    axis square;
    colormap jet;
    
    % Save figures in both PNG and EPS formats
    saveas(figDictionaryError, fullfile(figuresDir, ['Error_VanderPol_FBEDMD_eps_1e-4_times_' num2str(epsilon_values(ii)*10000) '.png']));
    print(figDictionaryError, fullfile(figuresEpsDir, ['Error_VanderPol_FBEDMD_eps_1e-4_times_' num2str(epsilon_values(ii)*10000)]), '-depsc');
end
