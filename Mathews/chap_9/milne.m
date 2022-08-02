function [T,Y] = milne(f,T,Y)
%---------------------------------------------------------------------------
%MILNE   Milne-Simpson solution for y' = f(t,y) with y(a) = ya.
% Remark
%   The first four coordinates of T and Y must
%   have starting values obtained with  RK4.m
% Sample call
%   [T,Y] = milne('f',T,Y)
% Inputs
%   f   name of the function 
%   T   vector for abscissas containing the first four values
%   Y   vector for ordinates containing the first four values
% Return
%   T   solution: vector of abscissas
%   Y   solution: vector of ordinates
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
% Algorithm  9.7 (Milne-Simpson Method).
% Section	9.6, Predictor-Corrector Method, Page 472
%---------------------------------------------------------------------------

n = length(T);
if n<5, break, end;
f0 = feval(f,T(1),Y(1));
f1 = feval(f,T(2),Y(2));
f2 = feval(f,T(3),Y(3));
f3 = feval(f,T(4),Y(4));
h  = T(2)-T(1);
a  = T(1);
pold = 0;
yold = 0;
for k = 4:n-1,
  pnew = Y(k-3) + 4*h*(2*f1 - f2 + 2*f3)/3;
  pmod = pnew + 28*(yold-pold)/29;
  T(k+1) = a + h*k;
  f4 = feval(f,T(k+1),pmod);
  Y(k+1) = Y(k-1) + h*(f2 + 4*f3 + f4)/3;
  pold = pnew;
  yold = Y(k+1);
  f1 = f2;
  f2 = f3;
  f3 = feval(f,T(k+1),Y(k+1));
end
