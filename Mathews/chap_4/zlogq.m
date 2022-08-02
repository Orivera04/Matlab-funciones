function [fun,dfun,ifun,x0,m,C,Ax] = zlogq
%---------------------------------------------------------------------------
%ZLOGQ   Taylor series coefficient lists for log(1+x)-log(1-x).
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
a = -0.9;
b = 0.9;
ymin = -3;
ymax = 3;
ymin1 = 0;
ymax1 = 10;
ymin2 = 0;
ymax2 = 1;
Ax(1,:) = [a b ymin ymax];
Ax(2,:) = [a b ymin1 ymax1];
Ax(3,:) = [a b ymin2 ymax2];
fun = 'log(1+x)-log(1-x)';
dfun = '(1-x).^(-1) + (1+x).^(-1)';
ifun = '-x.*log(1-x)+log(-1+x)+log(1+x)+x.*log(1+x)';
C = [2/25,
0,
2/23,
0,
2/21,
0,
2/19,
0,
2/17,
0,
2/15,
0,
2/13,
0,
2/11,
0,
2/9,
0,
2/7,
0,
2/5,
0,
2/3,
0,
2,
0];
