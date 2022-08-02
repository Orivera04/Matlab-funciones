function [fun,dfun,ifun,x0,m,C,Ax] = zacos
%---------------------------------------------------------------------------
%ZACOS   Taylor series coefficient lists for acos(x).
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
a = -0.999999;
b = 0.999999;
ymin = 0;
ymax = pi;
ymin1 = -4;
ymax1 = 0;
ymin2 = -2;
ymax2 = 1;
Ax(1,:) = [a b ymin ymax];
Ax(2,:) = [a b ymin1 ymax1];
Ax(3,:) = [a b ymin2 ymax2];
fun = 'acos(x)';
dfun = '-sqrt(1 - x.^2).^(-1)';
ifun = '1-sqrt(1 - x.^2) + x.*acos(x)';
C = [-676039/104857600,
0,
-88179/12058624,
0,
-46189/5505024,
0,
-12155/1245184,
0,
-6435/557056,
0,
-143/10240,
0,
-231/13312,
0,
-63/2816,
0,
-35/1152,
0,
-5/112,
0,
-3/40,
0,
-1/6,
0,
-1,
pi/2];
