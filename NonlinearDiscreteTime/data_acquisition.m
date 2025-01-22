%% Data Acquisition
% This script generates training data from a nonlinear discrete-time dynamical system

clear
clc

% Set seed for reproducibility
% This ensures that the random numbers generated will be the same each time
rng(123);

% System Parameters
numExperiments = 1000; % Total number of initial conditions to simulate
numSteps = 1;         % Number of time steps for each experiment

% Define the discrete-time nonlinear dynamical system
% The system is described by two coupled equations:
% x1(k+1) = 0.8 * x1(k)
% x2(k+1) = sqrt(0.9 * x2(k)^2 + x1(k) + 0.1)
dynamicMap = @(x) [ 0.8*x(1); sqrt( 0.9*x(2)^2 + x(1) + 0.1 )];

% Initialize data storage matrices
% X: Matrix storing current states [x1, x2]
% Y: Matrix storing next states [x1_next, x2_next]
X = [];
Y = [];

% Generate training data through simulation
for i = 1:numExperiments
    % Generate random initial conditions in the domain [0, 2]^2
    % x0 is a 2x1 vector containing initial values for both state variables
    x0 = 2 * rand(2, 1); % [x1_0; x2_0]
    
    % Initialize state vector for current experiment
    x = x0;
    
    % Simulate system evolution for specified number of steps
    for k = 1:numSteps
        % Store current state in X matrix
        X = [X; x'];
        
        % Compute next state using the dynamic map
        x_next = dynamicMap(x);
        
        % Store next state in Y matrix
        Y = [Y; x_next'];
        
        % Update current state for next iteration
        x = x_next;
    end
end

% Randomly shuffle the dataset to prevent any systematic bias
% This is important for training machine learning models
index = randperm(size(X,1));
X = X(index,:);
Y = Y(index,:);


%% Save Results
% Create output directory if it doesn't exist
output_dir = 'saved_data';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Save the generated dataset and dynamic map to a MAT file
% This data can be used later for training and validation
save(fullfile(output_dir, 'trajectory_data.mat'), 'X', 'Y', 'dynamicMap');


