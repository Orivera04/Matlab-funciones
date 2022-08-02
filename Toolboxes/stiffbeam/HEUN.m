function y = HEUN(ode, t, y, h, varargin)
% Heun-Algorithm
%    Executes one step of stepwidth h of the classical
%    Euler-Algorithm to solve a system of differential
%    equations of first order defined in 'ode'. HEUN requires the
%    same function format as Matlabs ODE... solvers.
% HEUN(ode, t, y, h, p1, p2, ...)
%    ode: Ordinary differential equation (Matlab format)
%    t  : Time variable
%    y  : values of preceding time step
%    h  : stepwidth
%    p1, ... pn : Funktion arguments passed to the ode file

% Authors: Stefan Hueeber
% Date   : October 21, 2002
% Version: 1.0

f = feval(ode, t, y, '', varargin{:});
y = y + 0.5*h*(f + feval(ode, t+h, y+h*f, '', varargin{:}));
