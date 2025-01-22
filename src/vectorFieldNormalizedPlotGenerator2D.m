function vectorFieldNormalizedPlotGenerator2D(func,y1val,y2val,t)
% VECTORFIELDNORMALIZEDPLOTGENERATOR2D Generate a normalized 2D vector field plot
%
% This function creates a vector field plot for a system of two first-order
% ordinary differential equations (ODEs), where all vectors are normalized to
% have the same length for better visualization.
%
% Syntax:
%   vectorFieldNormalizedPlotGenerator2D(func, y1val, y2val)
%   vectorFieldNormalizedPlotGenerator2D(func, y1val, y2val, t)
%
% Inputs:
%   func   - Function handle or string naming an m-file that returns a 2D vector
%            The function should accept time t and state vector [y1;y2] as inputs
%   y1val  - Vector of values for the first variable (x-axis)
%   y2val  - Vector of values for the second variable (y-axis)
%   t      - (Optional) Time value for evaluation (default: 0)
%
% Example:
%   y1 = linspace(-2,2,20);
%   y2 = linspace(-2,2,20);
%   vectorFieldNormalizedPlotGenerator2D(@mySystem, y1, y2)

% Set default time to 0 if not provided
if nargin==3
    t=0;
end

% Get dimensions of the grid
n1=length(y1val);
n2=length(y2val);

% Initialize arrays to store vector components
yp1=zeros(n2,n1);
yp2=zeros(n2,n1);

% Evaluate the vector field at each point in the grid
for i=1:n1
    for j=1:n2
        % Evaluate the function at current point
        ypv = feval(func,t,[y1val(i);y2val(j)]);
        % Store vector components
        yp1(j,i) = ypv(1);
        yp2(j,i) = ypv(2);
    end
end

% Calculate vector magnitudes for normalization
len=sqrt(yp1.^2+yp2.^2);

% Create normalized vector field plot
quiver(y1val,y2val,yp1./len,yp2./len,.5,'b','LineWidth',2);
% Note: Scale factor 0.5 is used for arrow size, blue color and linewidth 2 for visibility

% Adjust axis limits to fit the data
axis tight;
