function y = EULER(ode, t, y, h, varargin)
% Explizit Euler-Algorithm
%    Executes one step of stepwidth h of the classical
%    Euler-Algorithm to solve a system of differential
%    equations of first order defined in 'ode'. EULER requires the
%    same function format as Matlabs ODE... solvers.
% EULER(ode, t, y, h, p1, p2, ...)
%    ode: Ordinary differential equation (Matlab format)
%    t  : Time variable
%    y  : values of preceding time step
%    h  : stepwidth
%    p1, ... pn : Funktion arguments passed to the ode file
%
% Exoplizites Euler-Schema

% Authors: Stefan Hueeber
% Date   : October 21, 2002
% Version: 1.0

y = y + h*feval(ode, t, y, '', varargin{:});