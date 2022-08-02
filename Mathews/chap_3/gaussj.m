function  X = gaussj(A,B)
%---------------------------------------------------------------------------
%GAUSSJ   Gauss-Jordan method for solving a linear system.
%         Trivial pivoting is used.
% Sample call
%   X = gauss(A,B)
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
% Algorithm 3.g (Gauss-Jordan method).
% Section	3.4, Gaussian Elimination and Pivoting, Page 148
%---------------------------------------------------------------------------

[n n] = size(A);
A = [A';B']';
X = zeros(n,1);
for p = 1:n,
  for k = [1:p-1,p+1:n],
    if A(p,p)==0, break, end
    mult = A(k,p)/A(p,p);
    A(k,:) = A(k,:) - mult*A(p,:);
  end
end
X = A(:,n+1)./diag(A);
