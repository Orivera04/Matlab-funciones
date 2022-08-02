function [T,Y] = abm(f,T,Y)
%---------------------------------------------------------------------------
%ABM   Adams-Bashforth-Moulton solution for the
%      initial value problem  y' = f(t,y) with y(a) = ya.
% Remark
%   The first four coordinates of T and Y must
%   have starting values obtained with  RK4.m
% Sample call
%   [T,Y] = abm('f',T,Y)
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
% Algorithm 9.6 (Adams-Bashforth-Moulton Method).
% Section	9.6, Predictor-Corrector Method, Page 471
%---------------------------------------------------------------------------

n = length(T);
if n<5, break, end;
f0 = feval(f,T(1),Y(1));
f1 = feval(f,T(2),Y(2));
f2 = feval(f,T(3),Y(3));
f3 = feval(f,T(4),Y(4));
h  = T(2)-T(1);
h2 = h/24;
a  = T(1);
for k = 4:n-1,
  p = Y(k) + h2*(-9*f0 + 37*f1 - 59*f2 + 55*f3);
  T(k+1) = a + h*k;
  f4 = feval(f,T(k+1),p);
  Y(k+1) = Y(k) + h2*(f1 - 5*f2 + 19*f3 + 9*f4);
  f0 = f1;
  f1 = f2;
  f2 = f3;
  f3 = feval(f,T(k+1),Y(k+1));
end
