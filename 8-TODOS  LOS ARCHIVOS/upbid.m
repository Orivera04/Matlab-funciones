
function [A, V, U] = upbid(A)

% Bidiagonalization of the square matrix A using Golub-Kahan
% method. The reflection vectors of the left Householder
% matrices are saved in columns of the matrix V, while
% the reflection vectors of the right Householder
% reflections are saved in columns of the matrix U. Matrix
% A is overwritten with its upper bidiagonal form.

[m, n] = size(A);
if  m ~= n 
   error('Matrix must be square')
end
if  tril(triu(A),1) == A 
   V = eye(n-1);
   U = eye(n-2);
end
V = [];
U = [];
for k=1:n-1
   x = A(k:n,k);
   v = Housv(x);
   l = k:n;
   A(l,l) = A(l,l) - 2*v*(v'*A(l,l));
   v = [zeros(k-1,1);v];
   V = [V v];
   if  k < n-1 
      x = A(k,k+1:n)';
      u = Housv(x);
      p = 1:n;
      q = k+1:n;
      A(p,q) = A(p,q) - 2*(A(p,q)*u)*u';
      u = [zeros(k,1);u];
      U = [U u];
   end
end

    

