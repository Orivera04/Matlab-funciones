function [A,df] = diffnew(X,Y)
%---------------------------------------------------------------------------
%DIFFNEW   Numerical approximation for f'(x),
%          via differentiation of the Newton polynomial Pn(x).
%          An approximation for  f'(X(1))  is computed.
% Sample call
%   [A,df] = diffnew(X,Y)
% Inputs
%   X    vector of abscissas
%   Y    vector of ordinates
% Return
%   A    coefficient list for  Pn(x)
%   df   approximate derivative f'(X(1)) 
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
% Algorithm 6.3 (Differentiation Based on N+1 Nodes).
% Section	6.2, Numerical Differentiation Formulas, Page 342
%---------------------------------------------------------------------------

A = Y;
n = length(X);
for j=2:n,
  for k=n:-1:j,
      A(k) = (A(k)-A(k-1))/(X(k)-X(k-j+1));
  end
end
x0 = X(1);
df = A(2);
prod = 1;
n1 = length(A)-1;
for k=2:n1,
  prod = prod*(x0 - X(k));
  df = df + prod*A(k+1);
end
