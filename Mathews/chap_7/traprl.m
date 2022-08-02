function s = traprl(f,a,b,m)
%---------------------------------------------------------------------------
%TRAPRL   Quadrature using the trapezoidal rule.
% Sample call
%   s = traprl(f,a,b,m)
% Inputs
%   f    name of the function
%   a    left  endpoint of [a,b]
%   b    right endpoint of [a,b]
%   m    number of subintervals
% Return
%   s    trapezoidal rule quadrature value
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
% Algorithm 7.1 (Composite Trapezoidal Rule).
% Section	7.2, Composite Trapezoidal and Simpson's Rule, Page 365
%---------------------------------------------------------------------------

h  = (b - a)/m;
s = 0;
for k=1:(m-1),
  x = a + h*k;
  s = s + feval(f,x);
end
s = h*(feval(f,a)+feval(f,b))/2 + h*s;
