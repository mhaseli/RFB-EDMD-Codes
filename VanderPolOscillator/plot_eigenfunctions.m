%%% Eigenfunction Analysis and Visualization Script
% This script analyzes and visualizes the eigenfunctions obtained from the 
% Recursive Forward-Backward Extended Dynamic Mode Decomposition (RFB-EDMD) algorithm. It generates
% plots for eigenfunction magnitudes, phases, and associated prediction errors
% across the state space of the dynamical system.

%% Initialize Environment and Load Data
clear
close all
clc
% Add path to source directory containing RFB-EDMD implementation and utility functions
addpath('../src/')
% Load trained RB-EDMD results and system parameters
load('saved_data/RFB_EDMD_data.mat');  % Contains RFB-EDMD analysis results
load('saved_data/trajectory_data.mat');          % Contains system equations and parameters

% Apply the dictionary to the state matrices
DX = dictionary(X);
DY = dictionary(Y);

%% Compute EDMD Eigendecomposition
% Choose the identified subspace by RFB-EDMD appropraiate value for epsilon
subspace_index = 3;
fprintf('Selected subspace corresponds to epsilon = %.2e\n', epsilon_values(subspace_index));
C = rfb_C_cell{subspace_index};

% Apply EDMD on the identified subspace using original data
K = (DX*C)\(DY*C);

% Perform eigendecomposition of EDMD matrix
[eigvecs,eigvals] = eig(K);
eigvals = diag(eigvals);

% Define pruned dictionary function handle for efficient computation
dictionary_pruned = @(point) dictionary(point) * C;

%% Generate Eigenfunction Handles
% Create function handles for each eigenfunction for easy evaluation
numEigenfunctions = size(eigvecs, 2);
eigenfunctions = cell(numEigenfunctions, 1);

for ii = 1:numEigenfunctions
    eigenfunctions{ii} = @(point) dictionary_pruned(point) * eigvecs(:, ii);
end

%% Set Up Directory Structure
% Create main figures directory
figsDir = 'figures';
if ~exist(figsDir, 'dir')
    mkdir(figsDir);
end

% Create subdirectory for eigenfunction visualizations
figRelativeDir = fullfile(figsDir, 'figEigenfunction');
if ~exist(figRelativeDir, 'dir')
    mkdir(figRelativeDir);
end

% Create directories for different file formats
figuresDir = fullfile(figRelativeDir, 'figuresEig');
if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

figuresEpsDir = fullfile(figRelativeDir, 'figuresEigeps');
if ~exist(figuresEpsDir, 'dir')
    mkdir(figuresEpsDir);
end

%% Configure Global Plot Settings
% Set consistent visualization parameters across all plots
set(0, 'DefaultTextFontName', 'Times', ...
    'DefaultTextFontSize', 18 * 2, ...
    'DefaultAxesFontName', 'Times', ...
    'DefaultAxesFontSize', 18 * 2, ...
    'DefaultLineLineWidth', 1 * 2, ...
    'DefaultLineMarkerSize', 7.75 * 3);

%% Define State Space Grid
% Set domain boundaries and resolution for visualization
xMin = -3; xMax = 3;
yMin = -3; yMax = 3;
stepSize = 0.05;  % Grid resolution

% Generate 2D grid for state space visualization
[x, y] = meshgrid(xMin:stepSize:xMax, yMin:stepSize:yMax);
gridPoints = [x(:), y(:)];  % Convert grid to list of points

%% Plot Eigenfunction Magnitudes and Phases
% Iterate through each eigenfunction
for ii = 1:numEigenfunctions
    % Evaluate eigenfunction on the grid
    eigenfunctionValues = eigenfunctions{ii}(gridPoints);
    Z = reshape(eigenfunctionValues, size(x));
    
    if ~isreal(eigvals(ii))  % Check if eigenvalue is complex
        % Normalize magnitude for visualization
        absZNormalized = abs(Z) / max(abs(Z(:)));
        
        % Plot magnitude
        figAbs = figure;
        set(figAbs, 'Position', [100, 100, 800, 800]);
        surf(x, y, absZNormalized, 'EdgeColor', 'none');
        xlabel('$x_1$', 'Interpreter', 'latex');
        ylabel('$x_2$', 'Interpreter', 'latex');
        colorbar;
        view(0, 90);
        axis([xMin xMax yMin yMax]);
        axis square;
        colormap jet;
        % Save magnitude plots
        saveas(figAbs, fullfile(figuresDir, ['AbsValue_Eigenfunc_VanderPol_FBEDMD_' num2str(ii) '.png']));
        print(figAbs, fullfile(figuresEpsDir, ['AbsValue_Eigenfunc_VanderPol_FBEDMD_' num2str(ii)]), '-depsc');
        
        % Plot phase
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
        % Save phase plots
        saveas(figPhase, fullfile(figuresDir, ['Phase_Eigenfunc_VanderPol_FBEDMD_' num2str(ii) '.png']));
        print(figPhase, fullfile(figuresEpsDir, ['Phase_Eigenfunc_VanderPol_FBEDMD_' num2str(ii)]), '-depsc');
    else  % For real eigenvalues
        % Normalize values for visualization, ensuring maximum is +1
        [maxAbsValue, maxIdx] = max(abs(Z(:)));
        signFactor = sign(Z(maxIdx));
        ZNormalized = Z ./ (maxAbsValue * signFactor);  % Adjust sign to make max positive

        % Plot real-valued eigenfunction
        figReal = figure;
        set(figReal, 'Position', [100, 100, 800, 800]);
        surf(x, y, real(ZNormalized), 'EdgeColor', 'none');
        xlabel('$x_1$', 'Interpreter', 'latex');
        ylabel('$x_2$', 'Interpreter', 'latex');
        colorbar;
        view(0, 90);
        axis([xMin xMax yMin yMax]);
        axis square;
        colormap jet;
        % Save real eigenfunction plots
        saveas(figReal, fullfile(figuresDir, ['Real_Eigenfunc_VanderPol_FBEDMD_' num2str(ii) '.png']));
        print(figReal, fullfile(figuresEpsDir, ['Real_Eigenfunc_VanderPol_FBEDMD_' num2str(ii)]), '-depsc');
    end
end

%% Plot Eigenvalue Distribution
% Create visualization of eigenvalues and unit circle
figEigenvalues = figure;
set(figEigenvalues, 'Position', [100, 100, 800, 800]);


% Plot unit circle for reference
theta = linspace(0, 2*pi, 100);
unitCircleX = cos(theta);
unitCircleY = sin(theta);
plot(unitCircleX, unitCircleY, 'k:');
hold on;

% Plot eigenvalues
scatter(real(eigvals), imag(eigvals), 100, 'MarkerEdgeColor', [0 .5 .5], ...
    'MarkerFaceColor', [0 .7 .7]);
xlabel('Re($\lambda$)', 'Interpreter', 'latex');
ylabel('Im($\lambda$)', 'Interpreter', 'latex');
title('Eigenvalues and Unit Circle', 'Interpreter', 'latex');

% Configure plot appearance
axis equal;
xlim([-1.02, 1.02]);
ylim([-1.02, 1.02]);

% % Add unit circle annotation
% arrowStart = [0.64, 0.52];
% arrowEnd = [0.8, 0.7];
% annotation('textarrow', arrowStart, arrowEnd, 'String', 'Unit Circle', ...
%     'Interpreter', 'latex', 'FontSize', 24);

% Save eigenvalue plots
saveas(figEigenvalues, fullfile(figuresDir, 'Eigenvalues_UnitCircle_VanderPol_FBEDMD.png'));
print(figEigenvalues, fullfile(figuresEpsDir, 'Eigenvalues_UnitCircle_VanderPol_FBEDMD'), '-depsc');




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




%% Compute Eigenfunction Prediction Error
% Simulate system evolution for error calculation
finalPoints = zeros(size(gridPoints));

% Compute one-step evolution for each initial condition
for i = 1:size(gridPoints, 1)
    y0 = gridPoints(i, :);
    [t, ysim] = ode45(vanderPolEq, [0 sampleTime], y0);
    finalPoints(i, :) = ysim(end, :);
end

% Define normalized error function for eigenfunctions
normalized_eigenfunction_error = @(initialpoint,finalpoint,eigenfunction_index) ...
    abs(eigenfunctions{eigenfunction_index}(finalpoint) - eigvals(ii) .* ...
    eigenfunctions{eigenfunction_index}(initialpoint)) ./ ...
    max(abs(eigenfunctions{eigenfunction_index}(initialpoint)));

%% Plot Eigenfunction Prediction Errors
% Set consistent colorbar range for error plots
colorbar_range = [0, .06];

% Generate error plots for each eigenfunction
for ii = 1:numEigenfunctions
    % Calculate prediction error
    errorGrid = normalized_eigenfunction_error(gridPoints,finalPoints,ii);
    Z = reshape(errorGrid, size(x));
    
    % Create error visualization
    figError = figure;
    set(figError, 'Position', [100, 100, 800, 800]);
    surf(x, y, Z, 'EdgeColor', 'none');
    hColorbar = colorbar;
    colormap('jet')
    clim(colorbar_range);
    xlabel('$x_1$', 'Interpreter', 'latex');
    ylabel('$x_2$', 'Interpreter', 'latex');
    % colorbar;
    view(0, 90);
    axis([xMin xMax yMin yMax]);
    axis square;
    
    % Save error plots
    saveas(figError, fullfile(figuresDir, ['Error_Eigenfunc_VanderPol_FBEDMD_' num2str(ii) '.png']));
    print(figError, fullfile(figuresEpsDir, ['Error_Eigenfunc_VanderPol_FBEDMD_' num2str(ii)]), '-depsc');
end


