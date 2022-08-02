function [T,Y] = taylor(f,a,b,ya,m)
%---------------------------------------------------------------------------
%TAYLOR    Taylor's solution for y' = f(t,y) with y(a) = ya.
% Sample call
%   [T,Y] = taylor('f',a,b,ya,m)
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
% Algorithm 9.3 (Taylor's Method of Order 4).
% Section	9.4, Taylor Series Method, Page 448
%---------------------------------------------------------------------------

h = (b - a)/m;
T = zeros(1,m+1);
Y = zeros(1,m+1);
T(1) = a;
Y(1) = ya;
for j=1:m,
  tj = T(j);
  yj = Y(j);
  D = feval('df',tj,yj);
  Y(j+1) = yj + h*(D(1)+h*(D(2)/2+h*(D(3)/6+h*D(4)/24)));
  T(j+1) = a + h*j;
end
