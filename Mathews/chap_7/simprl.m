function s = simprl(f,a,b,m)
%---------------------------------------------------------------------------
%SIMPRL   Quadrature using Simpson`s rule.
% Sample call
%   s = simprl('f',a,b,m)
% Inputs
%   f   name of the function
%   a   left  endpoint of [a,b]
%   b   right endpoint of [a,b]
%   m   number of subintervals
% Return
%   s   Simpson rule quadrature value
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
% Algorithm 7.2 (Composite Simpson Rule).
% Section	7.2, Composite Trapezoidal and Simpson's Rule, Page 365
%---------------------------------------------------------------------------

h  = (b - a)/(2*m);
s1 = 0;
s2 = 0;
for k=1:m,
  x = a + h*(2*k-1);
  s1 = s1 + feval(f,x);
end
for k=1:(m-1),
  x = a + h*2*k;
  s2 = s2 + feval(f,x);
end
s = h*(feval(f,a)+feval(f,b)+4*s1+2*s2)/3;
