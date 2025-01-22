%% Plotting the dimension of the identified subspaces vs epsilon
clear
close all
clc
addpath('utils/')
load('yeastGlycolysisData_FB_EDMD.mat');  % loading the trained data


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

% Absolute Value Plot with normalization
    fig = figure;
    set(fig, 'Position', [100, 100, 800, 600]);
    stairs(eps, subspace_dim,'LineWidth',4); 
    xlabel('$\epsilon$', 'Interpreter', 'latex');
    ylabel('$\dim$', 'Interpreter', 'latex');
    ylim([0,350])

    % Save the figure in PNG and EPS
    saveas(fig, fullfile(figuresDir, 'Dimvseps_YeastGlycolysis.png'));
    print(fig, fullfile(figuresEpsDir, 'Dimvseps_YeastGlycolysis'), '-depsc');


