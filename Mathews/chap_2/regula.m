function [c,yc,err,P] = regula(f,a,b,delta,epsilon,max1)
%---------------------------------------------------------------------------
%REGULA   The Regula-Falsi method is used to locate a root.
% Sample calls
%   [c,yc,err] = regula('f',a,b,delta,epsilon,max1)
%   [c,yc,err,P] = regula('f',a,b,delta,epsilon,max1)
% Inputs
%   f         name of the function
%   a         left endpoint of the initial interval
%   b         right endpoint of the initial interval
%   delta     convergence tolerance for c
%   epsilon   convergence tolerance for yc
%   max1      maximum number of iterations
% Return
%   c         solution: the root
%   yc        solution: the function value
%   err       error estimate in the solution c
%   P         History vector of the iterations
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
% Algorithm 2.3 (False position or Regula Falsi Method).
% Section	2.2, Bracketing Methods for Locating a Root, Page 62
%---------------------------------------------------------------------------

P = [a b];
ya = feval(f,a);
yb = feval(f,b);
if ya*yb > 0, break, end
for k=1:max1,
  dx = yb*(b - a)/(yb - ya);
  c  = b - dx;
  ac = c - a;
  yc = feval(f,c);
  if  yc == 0,
    break;
  elseif  yb*yc > 0,
    b = c;
    yb = yc;
  else
    a = c;
    ya = yc;
  end
  P = [P;a b];
  dx = min(abs(dx),ac);
  if abs(dx) < delta,   break, end
  if abs(yc) < epsilon, break, end
end
err = abs(dx);
