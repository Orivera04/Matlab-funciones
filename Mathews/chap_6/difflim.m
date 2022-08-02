function [H,D,E,n] = difflim(f,x,toler)
%---------------------------------------------------------------------------
%DIFFLIM   Numerical approximation for f'(x).
%          The method employed is the limit process.
% Sample call
%   [H,D,E,n] = difflim('f',x,toler)
% Inputs
%   f   name of the function
%   x   differentiation point
% Return
%   H   vector of step sizes
%   D   vector of approximate derivatives
%   E   vector of error bounds
%   n   coordinate for D(n) "the best approximation for f'(x)"
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
% Algorithm 6.1 (Differentiation Using Limits).
% Section	6.1, Approximating the Derivative, Page 326
%---------------------------------------------------------------------------

h = 1;
max1 = 15;
H(1) = h;
D(1) = (feval(f,x+h) - feval(f,x-h))/(2*h);
E(1) = 0;
R(1) = 0;
for n = 1:2,
  h = h/10;
  H(n+1) = h;
  D(n+1) = (feval(f,x+h) - feval(f,x-h))/(2*h);
  E(n+1) = abs(D(n+1) - D(n));
  R(n+1) = 2*E(n+1)*(abs(D(n+1)) + abs(D(n)) + eps);
end
n = 2;
while ((E(n)>E(n+1)) & (R(n)>toler)) & n<max1
  h = h/10;
  H(n+2) = h;
  D(n+2) = (feval(f,x+h) - feval(f,x-h))/(2*h);
  E(n+2) = abs(D(n+2) - D(n+1));
  R(n+2) = 2*E(n+2)*(abs(D(n+2)) + abs(D(n+1)) + eps);
  n = n+1;
end
n = length(D)-1;
