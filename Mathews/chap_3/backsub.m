function  X = backsub(A,B)
%---------------------------------------------------------------------------
%BACKSUB   Back substitution solution for upper-triangular systems.
% Sample call
%   X = backsub(A,B)
% Inputs
%   A   upper-triangular coefficient matrix
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
% Algorithm 3.1 (Back Substitution).
% Section	3.3, Upper-Triangular Linear Systems, Page 145
%---------------------------------------------------------------------------

n = length(B);
det1 = A(n,n);
X = zeros(n,1);
X(n) = B(n)/A(n,n);
for r = n-1:-1:1,
  det1 = det1*A(r,r);
  if det1 == 0, break, end
  X(r) = (B(r) - A(r,r+1:n)*X(r+1:n))/A(r,r);
end
