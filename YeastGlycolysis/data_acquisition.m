%% Data Acquisition
% This script generates training data for the yeast glycolysis model by simulating multiple experiments with random initial conditions.
clear
clc

% Set seed for reproducibility
rng(123);

% Parameters
numExperiments = 1000; % Number of experiments to run
lengthExperiment = 3; % Total time of each experiment in seconds
sampleTime = 0.05; % Sampling time in seconds

% Parameters for the yeast glycolysis model
params = [
    2.5,    % J0
    100,    % k1
    6,      % k2
    16,     % k3
    100,    % k4
    1.28,   % k5
    12,     % k6
    1.8,    % k
    13,     % kappa
    4,      % q
    0.52,   % K1
    0.1,    % psi
    1,      % N
    4       % A
];

% Configure ODE solver options for high precision integration
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);

% Initialize matrices X and Y
% X will store the current states
% Y will store the next states (used for training prediction models)
X = [];
Y = [];

% Run multiple experiments with different initial conditions
for i = 1:numExperiments
    % Initial conditions randomly chosen from the set [0, 1]^7
    y0 = 1* rand(7, 1); % [y1_0; y2_0; y3_0; y4_0; y5_0; y6_0; y7_0]
    
    % Define time points for numerical integration
    tSpan = 0:sampleTime:lengthExperiment;
    
    % Solve the ODE system using ode45 (Runge-Kutta 4th/5th order method)
    [T, Y_sol] = ode45(@(t, y) yeastGlycolysisEq(t, y, params), tSpan, y0, opts);
    
    % Create input-output pairs for training:
    % X contains the current states (t)
    % Y contains the next states (t+1)
    % This format is suitable for training prediction models
    X = [X; Y_sol(1:end-1, :)];
    Y = [Y; Y_sol(2:end, :)];
end

% Randomly shuffle the data to prevent any temporal correlations
% during training and ensure better generalization
index = randperm(size(X,1));
X(index,:) = X;
Y(index,:) = Y;


%% Save Results
% Create output directory if it doesn't exist
output_dir = 'saved_data';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Store the generated data and system parameters for subsequent analysis
% X: Current states
% Y: Next states
% params: System parameters
% sampleTime: Time step between measurements
save(fullfile(output_dir, 'trajectory_data.mat'), 'X', 'Y', 'params', 'sampleTime');
