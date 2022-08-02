function [fun,dfun,ifun,x0,m,C,Ax] = zsqrt4
%---------------------------------------------------------------------------
%ZSQRT4   Taylor series coefficient lists for sqrt(4+x).
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
a = -3.9;
b = 4.0;
ymin = 0;
ymax = 3;
ymin1 = 0;
ymax1 = 1.6;
ymin2 = -6;
ymax2 = 10;
Ax(1,:) = [a b ymin ymax];
Ax(2,:) = [a b ymin1 ymax1];
Ax(3,:) = [a b ymin2 ymax2];
fun = 'sqrt(4+x)';
dfun = '(2.*sqrt(4+x)).^(-1)';
ifun = '(8/3+2.*x/3).*sqrt(4+x)-16/3';
C = [322476036831/79228162514264337593543950336,
-171529806825/9903520314283042199192993792,
11435320455/154742504910672534362390528,
-6116566755/19342813113834066795298816,
1641030105/1208925819614629174706176,
-883631595/151115727451828646838272,
119409675/4722366482869645213696,
-64822395/590295810358705651712,
17678835/36893488147419103232,
-9694845/4611686018427387904,
334305/36028797018963968,
-185725/4503599627370496,
52003/281474976710656,
-29393/35184372088832,
4199/1099511627776,
-2431/137438953472,
715/8589934592,
-429/1073741824,
33/16777216,
-21/2097152,
7/131072,
-5/16384,
1/512,
-1/64,
1/4,
2];
