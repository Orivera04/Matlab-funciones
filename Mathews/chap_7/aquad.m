function [quad,errb,cnt] = aquad(f,a,b,tol)
%---------------------------------------------------------------------------
%AQUAD   Adaptive quadrature using Simpson`s rule.
% Sample call
%   [quad,errb,cnt] = aquad('f',a,b,tol)
% Inputs
%   f      name of the function
%   a      left  endpoint of [a,b]
%   b      right endpoint of [a,b]
%   tol    convergence tolerance
% Return
%   quad   Adaptive Simpson quadrature value
%   err    error estimate
%   cnt    number of function evaluations
%   lev    level of recursion
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
% Algorithm 7.5a (Adaptive Quadrature Using Simpson's Rule).
% Section	7.4, Adaptive Quadrature, Page 389
%---------------------------------------------------------------------------

c = (a + b)/2;         % Starting initialization
fa = feval(f,a);       % which is required before
fb = feval(f,b);       % recursively calling the
fc = feval(f,c);       % subroutine  Aquadstep.
lev = 1;
sr0 = inf;
errb = 0;
% Now perform adaptive quadrature by recursive
% programming and using the subroutine  aqustep.
[quad,errb,cnt] = aqustep(f,a,c,b,fa,fc,fb,sr0,tol,lev);
cnt = cnt + 3;
