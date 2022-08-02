function [p,yp,dp,dy,A,B,C,D] = golden(f,a,b,delta,epsilon)
%---------------------------------------------------------------------------
%GOLDEN   Golden ratio search for a minimum.
% Sample calls
%   [p,yp,dp,dy,A,B,C,D] = golden('f',a,b,delta,epsilon)
%   [p,yp,dp,dy] = golden('f',a,b,delta,epsilon)
% Inputs
%   f         name of the function
%   a         left  endpoint of [a,b]
%   b         right endpoint of [a,b]
%   delta     convergence tolerance for the abscissas
%   epsilon   convergence tolerance for the ordinates
% Return
%   p         abscissa of the minimum
%   dp        ordinate of the minimum
%   dp        error bound for  p
%   dy        error bound for yp
%   A         vector of left  endpoints for the iteration
%   B         vector of right endpoints for the iteration
%   C         vector of central values  for the iteration
%   D         vector of central values  for the iteration
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
% Algorithm 8.1 (Golden Search for a Minimum).
% Section	8.1, Minimization of a Function, Page 413
%---------------------------------------------------------------------------

r1 = (sqrt(5)-1)/2;
r2 = r1^2;
h = b - a;
ya = feval(f,a);
yb = feval(f,b);
c = a + r2*h;
d = a + r1*h;
yc = feval(f,c);
yd = feval(f,d);
k = 1;
A(k) = a;
B(k) = b;
C(k) = c;
D(k) = d;
while (abs(yb-ya)>epsilon) | (h>delta)
  k = k+1;
  if (yc<yd),
    b = d;
    yb = yd;
    d = c;
    yd = yc;
    h = b - a;
    c = a + r2*h;
    yc = feval(f,c);
  else
    a = c;
    ya = yc;
    c = d;
    yc = yd;
    h = b - a;
    d = a + r1*h;
    yd = feval(f,d);
  end
  A(k) = a;
  B(k) = b;
  C(k) = c;
  D(k) = d;
end
dp = abs(b-a);
dy = abs(yb-ya);
p = a;
yp = ya;
if (yb<ya),
  p = b;
  yp = yb;
end
