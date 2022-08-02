function X = trisys(A,D,C,B)
%---------------------------------------------------------------------------
%TRISYS   Solution of a triangular linear system.
%         It is assumed that D and B have dimension n,
%         and that A and C have dimension n-1;
% Sample call
%   X = trisys(A,D,C,B)
% Inputs
%   A   sub diagonal vector
%   D   diagonal vector
%   C   super diagonal vector
%   B   right hand side vector
% Return
%   X   solution vector
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
% Algorithm 10.3 (Crank-Nicholson Method for the Heat Equation).
% Section	10.2, Parabolic Equations, Page 517
%---------------------------------------------------------------------------

n = length(B);
for k = 2:n,
  mult = A(k-1)/D(k-1);
  D(k) = D(k) - mult*C(k-1);
  B(k) = B(k) - mult*B(k-1);
end
X(n) = B(n)/D(n);
for k = (n-1):-1:1,
  X(k) = (B(k) - C(k)*X(k+1))/D(k);
end
