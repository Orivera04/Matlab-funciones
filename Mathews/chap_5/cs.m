function Z = cs(S,X,T)
%---------------------------------------------------------------------------
%CS   Evaluates the cubic spline created with csfit.
% Sample call
%   Z = cs(S,X,T)
% Inputs
%   S   matrix of spline coefficients
%   X   vector of abscissas
%   T   independent variable input value(s)
% Return
%   Z   function value(s)
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
% Algorithm 5.4 (Cubic Splines).
% Section	5.3, Interpolation by Spline Functions, Page 297
%---------------------------------------------------------------------------

n = length(X)-1;
m = length(T);
Z = zeros(1,m);
for i=1:m,
  t = T(i);
  j = 0;
  k = n-1;
  while (j<=n-1);
    j=j+1;
    if (t<=X(j+1)),
      k=j-1;
      j=n+1;
    end
  end
  if (t<=X(1)),
    k = 0;
  end
  w = t-X(k+1);
  z=((S(k+1,3+1)*w + S(k+1,2+1))*w + S(k+1,1+1))*w + S(k+1,0+1);
  Z(i) = z;
end
