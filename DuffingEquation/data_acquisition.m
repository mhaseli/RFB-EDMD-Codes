%% Data Acquisition for Duffing Equation Analysis
% This script generates synthetic data from the Duffing equation for subsequent
% analysis using the RFB-EDMD algorithm. 

% Initialize workspace
clear
clc

% Set random number generator seed for reproducibility
% This ensures consistent results across multiple runs
rng(123);

%% Simulation Parameters
numExperiments = 5000;    % Number of independent trajectories to simulate
lengthExperiment = 1;     % Duration of each trajectory (seconds)
sampleTime = 0.025;       % Time step between measurements (seconds)

% Define the Duffing equation system
duffingEq = @(t, y) [y(2); -0.5 * y(2) + y(1) - y(1)^3];

% Configure ODE solver options for high accuracy integration
% RelTol: Relative tolerance for step size control
% AbsTol: Absolute tolerance for step size control
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);

%% Data Collection
% Initialize state matrices
% X will store current states
% Y will store next states
X = [];
Y = [];

% Generate multiple trajectories
for i = 1:numExperiments
    % Generate random initial conditions in the range [-3, 3]^2
    % This range captures diverse dynamical behaviors
    y0 = 6 * rand(2, 1) - 3;  % [position; velocity]
    
    % Define time points for numerical integration
    tSpan = 0:sampleTime:lengthExperiment;
    
    % Solve the Duffing equation using ode45 (Runge-Kutta 4/5)
    [T, Y_sol] = ode45(duffingEq, tSpan, y0, opts);
    
    % Store state transitions
    % X contains states at time t
    % Y contains states at time t + dt
    X = [X; Y_sol(1:end-1, :)];
    Y = [Y; Y_sol(2:end, :)];
end

%% Data Processing
% Randomly shuffle the data to prevent any temporal correlations
% This improves the robustness of subsequent machine learning applications
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
% duffingEq: System dynamics
% sampleTime: Time step between measurements
save(fullfile(output_dir, 'trajectory_data.mat'), 'X', 'Y', 'duffingEq', 'sampleTime');


