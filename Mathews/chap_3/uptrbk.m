function  X = uptrbk(A,B)
%---------------------------------------------------------------------------
%UPTRBK   Upper-triangularization followed by back substitution.
%         Partial pivoting is used.
% Sample call
%   X = uptrbk(A,B)
% Inputs
%   A   coefficient matrix
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
% Algorithm 3.2 (Upper-Triangularization Followed by Back Substitution).
% Section	3.4, Gaussian Elimination and Pivoting, Page 156
%---------------------------------------------------------------------------

[n n] = size(A);
A = [A';B']';
X = zeros(n,1);
row = 1:n;       % Initialize the pointer vector.
for p = 1:n-1,
  [Max J] = max(abs(A(p:n,p)));  % Find the pivot row.
  T = row(p);
  row(p) = row(J+p-1);
  row(J+p-1) = T;  
  if  A(row(p),p) == 0, break, end
  for k = p+1:n,
    M = A(row(k),p)/A(row(p),p);
    A(row(k),p+1:n+1) = A(row(k),p+1:n+1) - M*A(row(p),p+1:n+1);
  end
end
X(n) = A(row(n),n+1)/A(row(n),n);
for k = n-1:-1:1,
  X(k) = (A(row(k),n+1) - A(row(k),k+1:n)*X(k+1:n))/A(row(k),k);
end
