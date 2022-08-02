function trans = rotationOz(varargin)
%ROTATIONOZ return 4x4 matrix of a rotation around z-axis
%
%   usage :
%   TRANS = rotationOz(THETA);
%   return the translation corresponding to angle THETA (in radians)
%   The returned matrix has the form :
%   [cos(theta)  sin(theta)  0 0]
%   [-sin(theta) cos(theta)  0 0]
%   [0           0           1 0]
%   [0           0           0 1]
%
%   TRANS = rotationOz(POINT, THETA);
%   TRANS = rotationOz(X0, Y0, THETA);
%   TRANS = rotationOz(X0, Y0, Z0, THETA);
%   Also specify origin of rotation. The result is similar as performing
%   translation(-dx, -dy, -dz), rotation, and translation(dx, dy, dz).
%
%
%   See also :
%   transformPoint, translation
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 06/04/2004.
%

% default values
dx = 0;
dy = 0;
dz = 0;
theta = 0;

% get input values
if length(varargin)==1
    % only angle
    theta = varargin{1};
elseif length(varargin)==2
    % origin point (as array) and angle
    var = varargin{1};
    dx = var(1);
    dy = var(2);
    theta = varargin{2};
elseif length(varargin)==3
    % origin (x and y) and angle
    dx = varargin{1};
    dy = varargin{2};
    theta = varargin{3};
end

% compute coefs
cot = cos(theta);
sit = sin(theta);
t = [1 0 0 dx;0 1 0 dy;0 0 1 dz;0 0 0 1];

% create transformation
trans = [...
    cot sit 0 0;...
    -sit cot 0 0;...
    0 0 1 0;...
    0 0 0 1];

trans = t*trans*inv(t);