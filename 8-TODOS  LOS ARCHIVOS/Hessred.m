
function [A, V] = Hessred(A)

% Reduction of the square matrix A to the upper 
% Hessenberg form using Householder reflectors.
% The reflection vectors are stored in columns of
% the matrix V. Matrix A is overwritten with its
% upper Hessenberg form.

[m,n] =size(A);
if A == triu(A,-1) 
   V = eye(m);
   return
end
V = [];
for k=1:m-2
   x = A(k+1:m,k);
   v = Housv(x);   
   A(k+1:m,k:m) = A(k+1:m,k:m) - 2*v*(v'*A(k+1:m,k:m));
   A(1:m,k+1:m) = A(1:m,k+1:m) - 2*(A(1:m,k+1:m)*v)*v';
   v = [zeros(k,1);v];
   V = [V v];
end



