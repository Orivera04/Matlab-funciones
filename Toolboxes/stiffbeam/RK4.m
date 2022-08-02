function y = RK4(ode, t, y, h, varargin)
% RK4 Runge-Kutta-Algorithm
%    Executes one step of stepwidth h of the classical
%    Runge-Kutta-Algorithm to solve a system of differential
%    equations of first order defined in 'ode'. rk4 requires the
%    same function format as Matlabs ODE... solvers.
% RK4(ode, t, y, h, p1, p2, ...)
%    ode: Ordinary differential equation (Matlab format)
%    t  : Time variable
%    y  : values of preceding time step
%    h  : stepwidth
%    p1, ... pn : Funktion arguments passed to the ode file
%
% Butcher-Scheme of the implemented Runge-Kutta-Method:
%   0   |
%	  0.5 | 0.5
%		0.5 |  0  0.5
%    1  |  0   0   1
%  ----------------------
%       | 1/6 2/6 2/6 1/6

% Authors: Bernd Flemisch, Andreas Klimke
% Date   : July 1, 2002
% Version: 1.0
	
k = zeros(length(y),4);
k(:,1) = feval(ode, t, y, '', varargin{:});
k(:,2) = feval(ode, t + 0.5*h, y + 0.5*h*k(:,1), '', varargin{:});
k(:,3) = feval(ode, t + 0.5*h, y + 0.5*h*k(:,2), '', varargin{:});
k(:,4) = feval(ode, t + h, y + h*k(:,3), '', varargin{:});
y = y + h * k * [1/6; 2/6; 2/6; 1/6];
