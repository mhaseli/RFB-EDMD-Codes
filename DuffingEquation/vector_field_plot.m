%% Vector Field Plot Generator for Duffing Equation
% This script generates and saves a vector field plot for the Duffing equation.
%
% Output files are saved in: figures/figVectorField/

% Clear workspace, close all figures, and clear command window
clear
close all
clc

% Add path to source directory containing RFB-EDMD implementation and utility functions
addpath('../src');

% Set global plotting defaults for consistent, publication-quality figures
% - Use Times font for all text and axes
% - Double the default font sizes (18 * 2)
% - Double line widths and triple marker sizes for better visibility
set(0, 'DefaultTextFontName', 'Times', ...
    'DefaultTextFontSize', 18 * 2, ...
    'DefaultAxesFontName', 'Times', ...
    'DefaultAxesFontSize', 18 * 2, ...
    'DefaultLineLineWidth', 1 * 2, ...
    'DefaultLineMarkerSize', 7.75 * 3);

% Define the Duffing equation system
duffingEq = @(t, y) [y(2); -0.5 * y(2) + y(1) - y(1)^3];

%% Generate and save the vector field plot
% Create new figure with specified size and position
vector_field = figure;
set(vector_field, 'Position', [100, 100, 800, 800]);  % Set figure size to 800x800 pixels

% Generate vector field plot using custom function
% Plot over domain x1, x2 ∈ [-2, 2] with step size 0.2
vectorFieldNormalizedPlotGenerator2D(duffingEq, -2:.2:2, -2:.2:2);

% Add LaTeX-formatted axis labels
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');

% Make the plot square and set specific y-axis ticks
axis square;
yticks([-2, -1, 0, 1, 2]);

% Create output directory if it doesn't exist
if ~exist('figures/figVectorField', 'dir')
    mkdir('figures/figVectorField');
end

% Save the figure in both EPS and PNG formats
% EPS for high-quality vector graphics (useful for publications)
% PNG for quick viewing and web usage
print('-depsc2', '-r600', 'figures/figVectorField/vector_field_duffing.eps');  % 600 dpi EPS file
saveas(vector_field, fullfile('figures/figVectorField', 'vector_field_duffing.png'));  % PNG file