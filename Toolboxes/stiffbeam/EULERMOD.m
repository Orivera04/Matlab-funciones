function y = EULERMOD(ode, t, y, h, varargin)
% Modified Euler-Algorithm
%    Executes one step of stepwidth h of the modified
%    Euler-Algorithm to solve a system of differential
%    equations of first order defined in 'ode'. EULER requires the
%    same function format as Matlabs ODE... solvers.
% EULER(ode, t, y, h, p1, p2, ...)
%    ode: Ordinary differential equation (Matlab format)
%    t  : Time variable
%    y  : values of preceding time step
%    h  : stepwidth
%    p1, ... pn : Funktion arguments passed to the ode file

% Authors: Stefan Hueeber
% Date   : October 25, 2002
% Version: 1.0

  fn = feval(ode, t, y, '', varargin{:});
y = y + h*feval(ode, t+0.5*h, y+0.5*h*fn, '', varargin{:});
