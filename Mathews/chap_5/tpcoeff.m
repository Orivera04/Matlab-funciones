function [A,B] = tpcoeff(X,Y,m)
%---------------------------------------------------------------------------
%TPCOEFF   Construct a trigonometric polynomial through the points.
% Sample call
%   [A,B] = tpcoeff(X,Y,m)
% Inputs
%   X   vector of equally spaced abscissas in [-pi,pi]
%   Y   vector of ordinates
%   m   degree of the trigonomitric polynomial
% Return
%   A   coefficients list for {cos(nx)}
%   B   coefficients list for {sin(nx)}
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
% Algorithm 5.5 (Trigonometric Polynomials).
% Section	5.4, Fourier Series and Trigonometric Polynomials, Page 311
%---------------------------------------------------------------------------

n = length(X)-1;
max1 = fix((n-1)/2);
if m>max1, m=max1; end
A = zeros(1,m+1);
B = zeros(1,m+1);
Yends = (Y(1)+Y(n+1))/2;
Y(1)   = Yends;
Y(n+1) = Yends;
A(1) = sum(Y);
for j = 1:m,
  A(j+1) = cos(j*X)*Y';
  B(j+1) = sin(j*X)*Y';
end
A = 2*A/n;
B = 2*B/n;
A(1) = A(1)/2;
