%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Motivating Example: EDMD Eigenfunction Analysis for Van der Pol Oscillator
%
% This script demonstrates how the Extended Dynamic Mode Decomposition (EDMD)
% method can produce spurious eigenfunctions when applied to nonlinear systems.
% The Van der Pol oscillator is used as a test case to illustrate this phenomenon.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Data Loading and Dictionary Application
% Clear workspace and configure environment
clear
close all
clc

% Add required paths and load data
addpath('../src/')  % Path to RFB-EDMD implementation and utilities
load('saved_data/trajectory_data.mat')  % Contains system equations and parameters

% Define parameters for dictionary generation
numStateVars = 2;  % Number of state variables in the system
maxPolyDegree = 8; % Maximum degree of polynomial terms in dictionary.
                   % Note: Despite favorable theoretical properties, polynomials of high
                   % degrees can lead to ill-conditioned matrices and numerical instability

% Generate monomial dictionary up to specified degree
% This forms a finite-dimensional approximation of the function space
dictionary = createVectorValuedMonomialFunc(numStateVars, maxPolyDegree);

% Transform state data using dictionary
DX = dictionary(X);  % Dictionary applied to initial states
DY = dictionary(Y);  % Dictionary applied to subsequent states

% Orthogonalize dictionary to improve numerical conditioning
Scaling_matrix = DX\orth(DX);  % Compute scaling for orthogonalization
DX = DX*Scaling_matrix;        % Apply scaling to initial states
DY = DY*Scaling_matrix;        % Apply scaling to subsequent states

% Update dictionary function with scaling
dictionary = @(point) dictionary(point) * Scaling_matrix;

%% Eigenfunction Computation and Visualization
% Compute EDMD approximation of Koopman operator
K = (DX)\(DY);

% Perform eigendecomposition of EDMD matrix
[eigvecs,eigvals] = eig(K);
eigvals = diag(eigvals);

% Generate eigenfunction approximations
numEigenfunctions = size(eigvecs, 2);
eigenfunctions = cell(numEigenfunctions, 1);

for ii = 1:numEigenfunctions
    % Each eigenfunction is composition of dictionary with eigenvector
    eigenfunctions{ii} = @(point) dictionary(point) * eigvecs(:, ii);
end

%% Visualization Parameters and Directory Setup
% Configure visualization settings for publication-quality figures
set(0, 'DefaultTextFontName', 'Times', ...
    'DefaultTextFontSize', 18 * 2, ...
    'DefaultAxesFontName', 'Times', ...
    'DefaultAxesFontSize', 18 * 2, ...
    'DefaultLineLineWidth', 1 * 2, ...
    'DefaultLineMarkerSize', 7.75 * 3);

% Domain specification for visualization
xMin = -3; xMax = 3;          % X-axis limits
yMin = -3; yMax = 3;          % Y-axis limits
stepSize = 0.05;              % Grid resolution

% Define the grid within the specified domain
[x, y] = meshgrid(xMin:stepSize:xMax, yMin:stepSize:yMax);
gridPoints = [x(:), y(:)]; % Convert grid to list of points

%% Error Analysis
% Compute pointwise eigenfunction errors across state space

% Simulate system evolution for one time step at each grid point
finalPoints = zeros(size(gridPoints));
for i = 1:size(gridPoints, 1)
    y0 = gridPoints(i, :);
    [t, ysim] = ode45(vanderPolEq, [0 sampleTime], y0);
    finalPoints(i, :) = ysim(end, :);
end

% Define normalized error function for eigenfunctions (normalized such that the maximum value of the eigenfunction is 1 over the domain)
normalized_eigenfunction_error = @(initialpoint,finalpoint,eigenfunction_index) ...
    abs(eigenfunctions{eigenfunction_index}(finalpoint) - ...
    eigvals(ii) .* eigenfunctions{eigenfunction_index}(initialpoint)) ./ ...
    max(abs(eigenfunctions{eigenfunction_index}(initialpoint)));

%% Ploting the absolute value and phase of each eigenfunction

% Ensure the 'figures' directory exists
% Create main figures directory
figsDir = 'figures';
if ~exist(figsDir, 'dir')
    mkdir(figsDir);
end

% Create subdirectory for eigenfunction visualizations
figRelativeDir = fullfile(figsDir, 'figMotivatingEDMDEigenfunctions');
if ~exist(figRelativeDir, 'dir')
    mkdir(figRelativeDir);
end

% Create directory for PNG figures
figuresDir = fullfile(figRelativeDir, 'figuresEig');
if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

% Create directory for EPS figures
figuresEpsDir = fullfile(figRelativeDir, 'figuresEigeps');
if ~exist(figuresEpsDir, 'dir')
    mkdir(figuresEpsDir);
end

% Loop to plot both Absolute Value (normalized) and Phase for each eigenfunction separately
for ii = 1:numEigenfunctions
    % Evaluate the ith eigenfunction on the grid
    eigenfunctionValues = eigenfunctions{ii}(gridPoints);
    Z = reshape(eigenfunctionValues, size(x)); % Reshape results back to a grid

    % Normalize the absolute value such that its maximum is 1 (this does not change the nature of the eigenfunction)
    absZNormalized = abs(Z) / max(abs(Z(:)));

    % Absolute Value Plot with normalization
    figAbs = figure;
    set(figAbs, 'Position', [100, 100, 800, 800]);
    surf(x, y, absZNormalized, 'EdgeColor', 'none'); % Use normalized absolute value
    xlabel('$x_1$', 'Interpreter', 'latex');
    ylabel('$x_2$', 'Interpreter', 'latex');
    colorbar;
    view(0, 90);
    axis([xMin xMax yMin yMax]);
    axis square;
    colormap jet;
    % Save the figure in PNG and EPS
    saveas(figAbs, fullfile(figuresDir, ['AbsValue_Eigenfunc_VanderPol_EDMD' num2str(ii) '.png']));
    print(figAbs, fullfile(figuresEpsDir, ['AbsValue_Eigenfunc_VanderPol_EDMD' num2str(ii)]), '-depsc');

    % Phase Plot
    figPhase = figure;
    set(figPhase, 'Position', [100, 100, 800, 800]);
    surf(x, y, angle(Z), 'EdgeColor', 'none');
    xlabel('$x_1$', 'Interpreter', 'latex');
    ylabel('$x_2$', 'Interpreter', 'latex');
    colorbar;
    view(0, 90);
    axis([xMin xMax yMin yMax]);
    axis square;
    colormap jet;
    % Save the figure in PNG and EPS
    saveas(figPhase, fullfile(figuresDir, ['Phase_Eigenfunc__VanderPol_EDMD' num2str(ii) '.png']));
    print(figPhase, fullfile(figuresEpsDir, ['Phase_Eigenfunc__VanderPol_EDMD' num2str(ii)]), '-depsc');
end

%% plotting eigenvalues

% Plot the complex eigenvalues and the unit circle

% Create a new figure with specified size
figEigenvalues = figure;
set(figEigenvalues, 'Position', [100, 100, 800, 600]);

% Plot the unit circle
theta = linspace(0, 2*pi, 100); % Parameter for the unit circle
unitCircleX = cos(theta);
unitCircleY = sin(theta);
plot(unitCircleX, unitCircleY, 'k:'); % Plot unit circle
hold on;

% Plot the eigenvalues
scatter(real(eigvals), imag(eigvals), 100, 'MarkerEdgeColor', [0 .5 .5], ...
    'MarkerFaceColor', [0 .7 .7]);
xlabel('Re($\lambda$)', 'Interpreter', 'latex');
ylabel('Im($\lambda$)', 'Interpreter', 'latex');
title('Eigenvalues and Unit Circle', 'Interpreter', 'latex');

% Additional plot settings
axis equal; % Ensure aspect ratio is 1:1
xlim([-1, 1.5]);
ylim([-1, 1]);


% Save the figure in PNG and EPS
saveas(figEigenvalues, fullfile(figuresDir, 'Eigenvalues_UnitCircle_VanderPol_EDMD.png'));
print(figEigenvalues, fullfile(figuresEpsDir, 'Eigenvalues_UnitCircle_VanderPol_EDMD'), '-depsc');

% Export eigenvalues to text files in both directories
eigenvalue_file_png = fullfile(figuresDir, 'eigenvalues.txt');
eigenvalue_file_eps = fullfile(figuresEpsDir, 'eigenvalues.txt');

% Write to figuresDir
fid = fopen(eigenvalue_file_png, 'w');
fprintf(fid, '%14s | %9s | %13s\n', 'Eigenvalue Index', 'Real Part', 'Imaginary Part');
fprintf(fid, '%14s-|-%9s-|-%13s\n', '--------------', '---------', '-------------');
for idx = 1:length(eigvals)
    fprintf(fid, '%14d | %9.6f | %13.6f\n', idx, real(eigvals(idx)), imag(eigvals(idx)));
end
fclose(fid);

% Write to figuresEpsDir
fid = fopen(eigenvalue_file_eps, 'w');
fprintf(fid, '%14s | %9s | %13s\n', 'Eigenvalue Index', 'Real Part', 'Imaginary Part');
fprintf(fid, '%14s-|-%9s-|-%13s\n', '--------------', '---------', '-------------');
for idx = 1:length(eigvals)
    fprintf(fid, '%14d | %9.6f | %13.6f\n', idx, real(eigvals(idx)), imag(eigvals(idx)));
end
fclose(fid);

%% Calculating and plotting the relative errors for all eigenfunctions
% computing error for a test

% Number of eigenfunctions
numEigenfunctions = size(eigvecs, 2);

% the range of the colorbar
colorbar_range = [0, 0.06];

% Loop to plot both Absolute Value (normalized) and Phase for each eigenfunction separately
for ii = 1:numEigenfunctions
    % Calculate the value for ith eigenfuncion on the grid
    errorGrid = normalized_eigenfunction_error(gridPoints,finalPoints,ii);
    Z = reshape(errorGrid, size(x)); % Reshape results back to a grid



    % Absolute Value Plot with normalization
    figError = figure;
    set(figError, 'Position', [100, 100, 800, 800]);
    surf(x, y, Z, 'EdgeColor', 'none'); % Use normalized absolute value
    hColorbar = colorbar; % Show a color bar indicating the scale and capture its handle
    colormap('jet')
    clim(colorbar_range);
    ylabel(hColorbar, '\%', 'Interpreter', 'latex'); % Set the label of the colorbar to '%' using LaTeX
    xlabel('$x_1$', 'Interpreter', 'latex');
    ylabel('$x_2$', 'Interpreter', 'latex');
    colorbar;
    view(0, 90);
    axis([xMin xMax yMin yMax]);
    axis square;
    % colormap jet;
    % Save the figure in PNG and EPS
    saveas(figError, fullfile(figuresDir, ['Error_Eigenfunc_VanderPol_EDMD_' num2str(ii) '.png']));
    print(figError, fullfile(figuresEpsDir, ['Error_Eigenfunc_VanderPol_EDMD_' num2str(ii)]), '-depsc');

end

