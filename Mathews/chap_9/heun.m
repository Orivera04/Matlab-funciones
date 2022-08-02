function [T,Y] = heun(f,a,b,ya,m)
%---------------------------------------------------------------------------
%HEUN   Heun's solution for y' = f(t,y) with y(a) = ya.
% Sample call
%   [T,Y] = heun('f',a,b,ya,m)
% Inputs
%   f    name of the function
%   a    left  endpoint of [a,b]
%   b    right endpoint of [a,b]
%   ya   initial value
%   m    number of steps
% Return
%   T    solution: vector of abscissas
%   Y    solution: vector of ordinates
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
% Algorithm 9.2 (Heun's Method).
% Section	9.3, Heun's Method, Page 441
%---------------------------------------------------------------------------

h = (b - a)/m;
T = zeros(1,m+1);
Y = zeros(1,m+1);
T(1) = a;
Y(1) = ya;
for j=1:m,
  k1 = feval(f,T(j),Y(j));
  p  = Y(j) + h*k1;
  T(j+1) = a + h*j;
  k2 = feval(f,T(j+1),p);
  Y(j+1) = Y(j) + h*(k1 + k2)/2;
end
