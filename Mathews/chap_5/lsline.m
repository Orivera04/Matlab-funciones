function [a,b] = lsline(X,Y)
%---------------------------------------------------------------------------
%LSLINE   Construct the least squares line.
% Sample call
%   [a,b] = lsline(X,Y)
% Inputs
%   X   vector of abscissas
%   Y   vector of ordinates
% Return
%   a   coefficient in the formula  y = ax+b
%   b   coefficient in the formula  y = ax+b
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
% Algorithm 5.1 (Least Squares Line).
% Section	5.1, Least-Squares Line, Page 264
%---------------------------------------------------------------------------

xmean = mean(X);
ymean = mean(Y);
sumx2 = (X-xmean)*(X-xmean)';
sumxy = (Y-ymean)*(X-xmean)';
a = sumxy/sumx2;
b = ymean-a*xmean;
