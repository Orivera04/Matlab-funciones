
function [Q, A] = Givred(A)

% Orthogonal transformation of a rectangular matrix A
% to the upper triangular matrix R using Givens
% rotations, so that A = Q*R, where Q is the
% orthogonal matrix. On the output matrix A is 
% overwritten with the matrix R. 

[m, n] = size(A);
if m == n 
   k = n-1;
elseif m > n 
   k = n;
else
   k = m-1;
end
Q = eye(m);
for j=1:k
   for i=j+1:m
      J = GivJ(A(j,j),A(i,j));
      A = preGiv(A,J,j,i);
      Q = preGiv(Q,J,j,i);
   end
end
Q = Q';
