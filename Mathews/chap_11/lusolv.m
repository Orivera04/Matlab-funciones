function  [X,Y] = lusolv(A,B,row)
%---------------------------------------------------------------------------
%LUSOLV   LU solution of a linear system.
%         Forward substitution followed
%         by back substitution is used.
% Remark
%    The matrix A must be in factored LU form,
%    and row is the required pivoting information.
% Sample call
%   [X,Y] = lusolv(A,B,row)
% Inputs
%   A     matrix obtained from LUfact
%   B     right hand side vector
%   row   pivoting information from LUfact
% Return
%   X     solution: to AX=B
%   Y     solution: to LY=PB
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
% Algorithm 11.2 (Shifted Inverse Power Method).
% Section	11.2, The Power Method, Page 558
%---------------------------------------------------------------------------

[n n] = size(A);
Y = zeros(n,1);
Y(1) = B(row(1));
for k = 2:n,
  Y(k) = B(row(k)) - A(row(k),1:k-1)*Y(1:k-1);
end
X = zeros(n,1);
X(n) = Y(n)/A(row(n),n);
for k = n-1:-1:1,
  X(k) = (Y(k) - A(row(k),k+1:n)*X(k+1:n))/A(row(k),k);
end
