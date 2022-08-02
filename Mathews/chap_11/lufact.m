function  [A,row,det1] = lufact(A)
%---------------------------------------------------------------------------
%LUFACT   LU factorization of a matrix.
%         Partial pivoting is used.
% Sample call
%   [LU,row,det1] = lufact(A)
% Inputs
%   A     matrix
% Return
%   LU    solution: factored matrix
%   row   solution: row permutation information
%   det1  solution: determinant of A
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
det1 = 1;
row = 1:n;                              % Initialize pointer vector.
for p = 1:n-1,
  [max1 prow] = max(abs(A(p:n,p)));     % Find the pivot row.
  if p < prow+p-1,
    temp = row(p); 
    row(p) = row(prow+p-1);
    row(prow+p-1) = temp; 
    det1 = - det1;
  end
  det1 = det1*A(row(p),p);
  if  det1 == 0, break, end
  for k = p+1:n,
    mult = A(row(k),p)/A(row(p),p);
    A(row(k),p) = mult;
    A(row(k),p+1:n) = A(row(k),p+1:n) - mult*A(row(p),p+1:n);
  end
end
det1 = det1*A(row(n),n);
