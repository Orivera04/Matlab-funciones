function [fun,dfun,ifun,x0,m,C,Ax] = zcosh
%---------------------------------------------------------------------------
%ZCOSH   Taylor series coefficient lists for cosh(x).
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
m = 24;
a = -10;
b = 10;
ymin = 0;
ymax = 10000;
ymin1 = -10000;
ymax1 = 10000;
ymin2 = -10000;
ymax2 = 10000;
Ax(1,:) = [a b ymin ymax];
Ax(2,:) = [a b ymin1 ymax1];
Ax(3,:) = [a b ymin2 ymax2];
fun = 'cosh(x)';
dfun = 'sinh(x)';
ifun = 'sinh(x)';
C = [1/620448401733239439360000,
0,
1/1124000727777607680000,
0,
1/2432902008176640000,
0,
1/6402373705728000,
0,
1/20922789888000,
0,
1/87178291200,
0,
1/479001600,
0,
1/3628800,
0,
1/40320,
0,
1/720,
0,
1/24,
0,
1/2,
0,
1];
