function [fun,dfun,ifun,x0,m,C,Ax] = zemx2d2
%---------------------------------------------------------------------------
%ZEMX2D2   Taylor series coefficient lists for exp(-x^2/2).
%          Pm(x) = c(1) + c(2)x + c(2)x^2 + ... + c(m+1)x^m
% Inputs
%   There are no inputs for this function.
% Return
%   fun    name of the function f(x)
%   dfun   name of the derivative f'(x)
%   ifun   name of the integral  Ÿf(x)dx
%   x0     point of expansion
%   m      degree of the polynomial
%   C      coefficient list of the polynomial
%   Ax     three asis vectors plotting f, f' and Ÿf
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
% Algorithm 4.1 (Evaluation of a Taylor Series).
% Section	4.1, Taylor Series and Calculation of Functions, Page 203
% Algorithm 4.2 (Polynomial Calculus).
% Section	4.2, Introduction to Interpolation, Page 212
% Algorithm 4.p (Pade rational Approximation).
% Section	4.6, Pade Approximations, Page 249
%---------------------------------------------------------------------------

x0 = 0; 
m = 24;
a = -3;
b = 3;
ymin = -0.1;
ymax = 1.05;
ymin1 = -10;
ymax1 = 10;
ymin2 = -1.5;
ymax2 = 1.5;
Ax(1,:) = [a b ymin ymax];
Ax(2,:) = [a b ymin1 ymax1];
Ax(3,:) = [a b ymin2 ymax2];
fun = 'exp(-x.^2/2)';
dfun = '-x./exp(-x.^2/2)';
ifun = 'sqrt(pi/2).*erf(x./sqrt(2))';
C = [1/1961990553600,
0,
-1/81749606400,
0,
1/3715891200,
0,
-1/185794560,
0,
1/10321920,
0,
-1/645120,
0,
1/46080,
0,
-1/3840,
0,
1/384,
0,
-1/48,
0,
1/8,
0,
-1/2,
0,
1];
