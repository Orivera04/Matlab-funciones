function [fun,dfun,ifun,x0,m,C,Ax] = zatan
%---------------------------------------------------------------------------
%ZATAN   Taylor series coefficient lists for atan(x).
%        Pm(x) = c(1) + c(2)x + c(2)x^2 + ... + c(m+1)x^m
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
m = 25;
a = -1;
b = 1;
ymin = -1;
ymax = 1;
ymin1 = 0;
ymax1 = 1;
ymin2 = 0;
ymax2 = 0.5;
Ax(1,:) = [a b ymin ymax];
Ax(2,:) = [a b ymin1 ymax1];
Ax(3,:) = [a b ymin2 ymax2];
fun = 'atan(x)';
dfun = '(1 + x.^2).^(-1)';
ifun = 'x.*atan(x) - log(1 + x.^2)/2';
C = [1/25,
0,
-1/23,
0,
1/21,
0,
-1/19,
0,
1/17,
0,
-1/15,
0,
1/13,
0,
-1/11,
0,
1/9,
0,
-1/7,
0,
1/5,
0,
-1/3,
0,
1,
0];
