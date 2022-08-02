function T = rctrap(f,a,b,n)
%---------------------------------------------------------------------------
%RCTRAP   Quadrature using the recursive trapezoidal rule.
% Sample call
%   T = rctrap('f',a,b,n)
% Inputs
%   f   name of the function
%   a   left  endpoint of [a,b]
%   b   right endpoint of [a,b]
%   n   number of levels for recursion
% Return
%   T   recursive trapezoidal rule list
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
% Algorithm 7.3 (Recursive Trapezoidal Rule).
% Section	7.3, Recursive Rules and Romberg Integration, Page 378
%---------------------------------------------------------------------------

m = 1;
h = b - a;
T = zeros(1,n+1);
T(1) = h*(feval(f,a) + feval(f,b))/2;
for j = 1:n,
  m = 2*m;
  h = h/2;
  s = 0;
  for k=1:m/2,
    x = a + h*(2*k-1);
    s = s + feval(f,x);
  end
  T(j+1) = T(j)/2 + h*s;
end
