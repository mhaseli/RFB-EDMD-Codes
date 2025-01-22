%%% The Effect of Change of coordinates on the residual error of EDMD
% This script analyzes how changing the coordinate system affects the residual error of EDMD
% (Extended Dynamic Mode Decomposition) 
%
% The residual error of EDMD is compared with the consistency index introduced in:
% https://doi.org/10.1109/LCSYS.2022.3214476
% which is a special case of the concept of invariance proximity discussed in:
% https://doi.org/10.48550/arXiv.2311.13033

%% Initialize workspace and load data
clear
close all
clc

% Add required paths and load data
addpath('../src/')  % Path to RFB-EDMD implementation and utilities
load('saved_data/trajectory_data.mat')  % Contains system equations and parameters

% Create dictionary of basis functions
% Using monomials up to degree 8 in 2 variables
dictionary = createVectorValuedMonomialFunc(2,8);

% Apply dictionary transformations to data matrices
% X contains the current states, Y contains the next states
DX = dictionary(X);  % Transform current states
DY = dictionary(Y);  % Transform next states

%% Analyze system behavior for different scaling parameters
% Create logarithmically spaced values for alpha from 10^-8 to 10^0
alpha_vec = logspace(-8,0,20);

% Initialize vectors to store different error metrics
E_residual_alpha_vec = zeros(size(alpha_vec));  % Absolute residual errors
E_relative_alpha_vec = zeros(size(alpha_vec));  % Relative residual errors
RRMSE_max_alpha_vec = zeros(size(alpha_vec));   % Maximum RRMSE (Root Relative Mean Square Error)

% Loop through different alpha values
for jj = 1:length(alpha_vec)
    alpha = alpha_vec(jj);
    
    % Apply coordinate transformation
    % Each basis function f is transformed to 1 + alpha*f, except constant terms
    DX_alpha = change_of_basis(DX,alpha);  % Transform current states
    DY_alpha = change_of_basis(DY,alpha);  % Transform next states
    
    % Compute error metrics in new coordinate system
    % Calculate absolute residual error using Frobenius norm
    E_residual_alpha = norm(DY_alpha - DX_alpha *(DX_alpha\DY_alpha),'fro');
    
    % Calculate relative residual error
    E_relative_alpha = E_residual_alpha/norm(DY_alpha,'fro');
    
    % Calculate invariance proximity using largest eigenvalue of Consistency Matrix
    % This measures how well the coordinate transformation preserves system dynamics
    RRMSE_max_alpha = sqrt( eigs( eye(size(DX_alpha,2)) - (DX_alpha\DY_alpha)*(DY_alpha\DX_alpha) ,1 ) ); 
    
    % Store results
    E_residual_alpha_vec(jj) = E_residual_alpha;
    E_relative_alpha_vec(jj) = E_relative_alpha;
    RRMSE_max_alpha_vec(jj) = RRMSE_max_alpha;
end

%% Visualization
% Create directory for saving figures
figuresDir = 'figures/figuresMotivatingResidualCoordinates';
if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end

% Set global plotting parameters
% Adjust font sizes and line properties for better visibility
set(0, 'DefaultTextFontName', 'Times', ...
    'DefaultTextFontSize', 18 * 2, ...
    'DefaultAxesFontName', 'Times', ...
    'DefaultAxesFontSize', 18 * 2, ...
    'DefaultLineLineWidth', 1 * 5, ...
    'DefaultLineMarkerSize', 7.75 * 3);

% Plot 1: Absolute Residual Error
figresidualerror = figure;
set(figresidualerror, 'Position', [100, 100, 800, 600]);  % Set figure size
semilogx(alpha_vec, E_residual_alpha_vec)
xlim([1e-8,1])
xlabel('$\alpha$', 'Interpreter', 'latex')
ylabel('$E$', 'Interpreter', 'latex')
% Save both PNG and EPS versions
saveas(figresidualerror, fullfile(figuresDir, 'EDMD_residual_error_vanderpol.png'));
print(figresidualerror, fullfile(figuresDir, 'EDMD_residual_error_vanderpol'), '-depsc');

% Plot 2: Relative Residual Error
figrelativeresidualerror = figure;
set(figrelativeresidualerror, 'Position', [100, 100, 800, 600]);
semilogx(alpha_vec, E_relative_alpha_vec)
xlim([1e-8,1])
ylim([0,.015])
xlabel('$\alpha$', 'Interpreter', 'latex')
ylabel('$E_r$', 'Interpreter', 'latex')
% Save both PNG and EPS versions
saveas(figrelativeresidualerror, fullfile(figuresDir, 'EDMD_relative_residual_error_vanderpol.png'));
print(figrelativeresidualerror, fullfile(figuresDir, 'EDMD_relative_residual_error_vanderpol'), '-depsc');

% Plot 3: Consistency Index (RRMSE_max)
figconsistency = figure;
set(figconsistency, 'Position', [100, 100, 800, 600]);
semilogx(alpha_vec, RRMSE_max_alpha_vec)
xlim([1e-8,1])
xlabel('$\alpha$', 'Interpreter', 'latex')
ylabel('RRMSE$_{\max}$', 'Interpreter', 'latex');
ylim([0,.8])
% Save both PNG and EPS versions
saveas(figconsistency, fullfile(figuresDir, 'consistency_index_sqrt_vanderpol.png'));
print(figconsistency, fullfile(figuresDir, 'consistency_index_sqrt_vanderpol'), '-depsc');