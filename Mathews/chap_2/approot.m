function  R = approot(X,Y,epsilon)
%---------------------------------------------------------------------------
%APPROOT   Finds the approximate locations for roots.
% Sample call
%   R = approot(X,Y,epsilon)
% Inputs
%   X         vector of abscissas
%   Y         vector of ordinates
%   epsilon   tolerance for answer(s)
% Return
%   R         vector of approximate locations for roots
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
% Algorithm 2.4 (Approximate Location of Roots).
% Section	2.3, Initial Approximations & Convergence Criteria, Page 70
%---------------------------------------------------------------------------

yrange   = max(Y)-min(Y);
epsilon2 = yrange*epsilon;
n = length(X);
m = 0;
X(n+1) = X(n);
Y(n+1) = Y(n);
for k=2:n,
  if  Y(k-1)*Y(k) <= 0,
    m = m + 1;
    R(m) = (X(k-1)+X(k))/2;
  end
  s = (Y(k) - Y(k-1))*(Y(k+1) - Y(k));
  if  (abs(Y(k)) < epsilon2) & (s <= 0),
    m = m + 1;
    R(m) = X(k);
  end
end
