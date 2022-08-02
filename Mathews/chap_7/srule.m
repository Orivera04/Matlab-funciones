function Z = srule(f,a0,b0,tol0)
%---------------------------------------------------------------------------
%SRULE   Subroutine for adaptive quadrature.
% Sample call
%   Z = srule('f',a0,b0,tol0)
% Inputs
%   f      name of the function
%   a0     left  endpoint of [a0,b0]
%   b0     right endpoint of [a0,b0]
%   tol0   convergence tolerance
% Return
%   Z      Simpson rule quadrature value
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 7.5 (Adaptive Quadrature Using Simpson's Rule).
% Section	7.4, Adaptive Quadrature, Page 389
%---------------------------------------------------------------------------

h  = (b0 - a0)/2;
c0 = (a0 + b0)/2;
Fa = feval(f,a0);
Fc = feval(f,c0);
Fb = feval(f,b0);
S  = h*(Fa + 4*Fc + Fb)/3;
S2 = S;
tol1 = tol0;
err  = tol0;
Z = [a0 b0 S S2 err tol1];




