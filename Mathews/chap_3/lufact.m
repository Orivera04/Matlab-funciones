function  [LU,row,det1] = lufact(A)
%---------------------------------------------------------------------------
%LUFACT   Factorization using partial pivoting.
% Sample call
%   [LU,row,det1] = lufact(A)
% Remark
%   The outputs  LU and row  are used by the function  lusolv.
% Inputs
%   A      coefficient matrix
% Return
%   LU     factored matrix needed by  lusolv
%   row    row permutation information needed by  lusolv
%   det1   the determinant of A
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
% Algorithm 3.3 (PA = LU Factorization with Pivoting).
% Section	3.6, Triangular Factorizaton, Page 175
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
LU = A;
