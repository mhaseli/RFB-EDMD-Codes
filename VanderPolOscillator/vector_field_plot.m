%% Vector Field Plot Generator for Van der Pol Oscillator
% This script generates and saves a vector field plot for the Van der Pol oscillator.
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


%% Define the Van der Pol oscillator equation and a trajectory for identifying the limit cycle
    % mu is the damping parameter that controls the nonlinearity strength
    mu = 1; % mu parameter for the Van der Pol oscillator

    % Define the Van der Pol oscillator equation
    % y(1) is position, y(2) is velocity
    % The equation is: x'' - mu(1-x^2)x' + x = 0
    vanderPolEq = @(t, y) [y(2); mu * (1 - y(1)^2) * y(2) - y(1)];
    [ts,ys] = ode45(vanderPolEq,[0,40],[+3;.5]);

%% Generate and save the vector field plot
% Create new figure with specified size and position
vector_field = figure;
set(vector_field, 'Position', [100, 100, 800, 800]);  % Set figure size to 800x800 pixels

% Plot the limit cycle first
hold on
plot(ys((end/2):end,1),ys((end/2):end,2),'g',LineWidth=5)

% Generate vector field plot using custom function
% Plot over domain x1, x2 ∈ [-4, 4] with step size 0.4
vectorFieldNormalizedPlotGenerator2D(vanderPolEq, -4:0.4:4, -4:0.4:4);

% Add LaTeX-formatted axis labels
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');

% Make the plot square and set specific axis ticks
axis square;
xticks([-4, -2, 0, 2, 4]);
yticks([-4, -2, 0, 2, 4]);

% Create output directory if it doesn't exist
if ~exist('figures/figVectorField', 'dir')
    mkdir('figures/figVectorField');
end

% Save the figure in both EPS and PNG formats
% EPS for high-quality vector graphics (useful for publications)
% PNG for quick viewing and web usage
print('-depsc2', '-r600', 'figures/figVectorField/vector_field_VanderPol.eps');  % 600 dpi EPS file
saveas(vector_field, fullfile('figures/figVectorField', 'vector_field_VanderPol.png'));  % PNG file