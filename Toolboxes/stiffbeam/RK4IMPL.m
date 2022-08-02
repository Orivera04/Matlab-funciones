function [y,l] = RK4IMPL(ode, t, y, h, varargin)
% RK4IMPL Runge-Kutta-Algorithm
%    Executes one step of stepwidth h of the implicit 
%    Runge-Kutta-Algorithm of Hammer and Hollingsqorth to 
%    solve a system of differential equations of first order 
%    defined in 'ode'. RK2IMPL requires the
%    same function format as Matlabs ODE... solvers.
%    the algortihm is of order4
%    y  : values of next time step
%    n  : number of inner itaerations
% RK4IMPL(ode, t, y, h, p1, p2, ...)
%    ode: Ordinary differential equation (Matlab format)
%    t  : Time variable
%    y  : values of preceding time step
%    h  : stepwidth
%    p1, ... pn : Funktion arguments passed to the ode file
%
% Butcher-Scheme of the implemented Runge-Kutta-Method:
%   1/2 - \sqrt(3)/6  |      1/4          1/4 - \sqrt(3)/6 
%   1/2 + \sqrt(3)/6  | 1/4 + \sqrt(3)/6        1/4
%  --------------------------------------------------------
%                     |      1/2                1/2
%
% Authors: Stefan Hüeber
% Date   : November 4, 2002
% Version: 1.0

tol = 10e-6;
MAXSTEP = 500;

% Computation of the coefficients
alpha =[ 0.5 - sqrt(3)/6; 0.5 + sqrt(3)/6 ];
beta = [ 0.25 - sqrt(3)/6; 0.25 + sqrt(3)/6 ];

% Initialization of k and l
knew = zeros(length(y),2);
kold = ones(length(y),2);

l = 0;
% Computation of k
while (norm([knew(:,1);knew(:,2)]-[kold(:,1);kold(:,2)]) > tol) & (l < MAXSTEP)
	kold = knew;
	knew(:,1) = feval(ode, t+h*alpha(1),...
										y+h*(0.25*kold(:,1)+beta(1)*kold(:,2)), ...
										'', varargin{:});
	knew(:,2) = feval(ode, t+h*alpha(2),...
										y+h*(beta(2)*kold(:,1)+0.25*kold(:,2)), ...
										'', varargin{:});
	l = l+1;
end

% compute y_{i+1}
y = y + h * knew *[ 0.5; 0.5 ];