%% Plotting the dimension of the identified subspaces vs epsilon
clear
close all
clc
% Add path to source directory containing RFB-EDMD implementation and utility functions
addpath('../src/')
load('saved_data/RFB_EDMD_data.mat');  % loading the trained data
load('saved_data/TSSD_data.mat');  % loading the trained data


% Ensure the 'figures' directory exists
figsDir = 'figures';
if ~exist(figsDir, 'dir')
    mkdir(figsDir);
end

% Ensure the 'figRelative' subfolder exists inside figures
figRelativeDir = fullfile(figsDir, 'figDimension');
if ~exist(figRelativeDir, 'dir')
    mkdir(figRelativeDir);
end

% Ensure the figuresRelative directory exists inside figRelative for PNGs
figuresDir = fullfile(figRelativeDir, 'figuresDimension');
if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

% Ensure the figuresRelativeeps directory exists inside figRelative for EPS
figuresEpsDir = fullfile(figRelativeDir, 'figuresDimensioneps');
if ~exist(figuresEpsDir, 'dir')
    mkdir(figuresEpsDir);
end




% Setting the default font sizes
set(0, 'DefaultTextFontName', 'Times', ...
    'DefaultTextFontSize', 18 * 2, ...
    'DefaultAxesFontName', 'Times', ...
    'DefaultAxesFontSize', 18 * 2, ...
    'DefaultLineLineWidth', 1 * 2, ...
    'DefaultLineMarkerSize', 7.75 * 3);


    fig = figure;
    set(fig, 'Position', [100, 100, 800, 600]);
    stairs(epsilon_values, tssd_subspace_dim,'LineWidth',4);
    hold on 
    stairs(epsilon_values, rfb_subspace_dim,'LineWidth',4);
    legend('T-SSD', 'RFB-EDMD', 'Location', 'northwest');
    xlabel('$\epsilon$', 'Interpreter', 'latex');
    ylabel('$\dim$', 'Interpreter', 'latex');

    % Save the figure in PNG and EPS
    saveas(fig, fullfile(figuresDir, 'Dimvseps_YeastGlycolysis.png'));
    print(fig, fullfile(figuresEpsDir, 'Dimvseps_YeastGlycolysis'), '-depsc');


