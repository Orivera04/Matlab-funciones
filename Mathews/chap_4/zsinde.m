function [fun,dfun,ifun,x0,m,C,Ax] = zsinde
%---------------------------------------------------------------------------
%ZSINDE   Taylor series coefficient lists for sin(x)/exp(x).
%         Pm(x) = c(1) + c(2)x + c(2)x^2 + ... + c(m+1)x^m
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
a = 0;
b = 2*pi;
ymin = -0.05;
ymax = 0.4;
ymin1 = -0.3;
ymax1 = 1;
ymin2 = 0;
ymax2 = 0.6;
Ax(1,:) = [a b ymin ymax];
Ax(2,:) = [a b ymin1 ymax1];
Ax(3,:) = [a b ymin2 ymax2];
fun = 'sin(x)./exp(x)';
dfun = 'cos(x)./exp(x) - sin(x)./exp(x)';
ifun = '1/2-cos(x)./(2.*exp(x)) - sin(x)./(2.*exp(x))';
C = [1/3786916514485104000000,
0,
-1/12623055048283680000,
1/548828480360160000,
-1/49893498214560000,
0,
1/237588086736000,
-1/12504636144000,
1/1389404016000,
0,
-1/10216206000,
1/681080400,
-1/97297200,
0,
1/1247400,
-1/113400,
1/22680,
0,
-1/630,
1/90,
-1/30,
0,
1/3,
-1,
1,
0];
