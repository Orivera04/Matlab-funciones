
function [la, v] = Rqi(A, v, iter)

% The Rayleigh quotient iteration. 
% Vector v is an approximation to the eigenvector  
% of the matrix A. The dominant eigenvalue la and the 
% associated eigenvector v are computed.
% Iterative process is terminated either if
% norm(A*v - la*v,1) < norm(A,1)*length(v)*eps
% or if the number of performed iterations is equal to iter.

if norm(v) > 1
   v = v/norm(v);
end
la = v'*A*v;
tol = norm(A,1)*length(v)*eps;
for k=1:iter
      if norm(A*v - la*v,1) < tol
         return
      else
         B = A - la*eye(size(A));
         [L,U,P]=lu(B);
         w = U\(L\(P*v));
         v = w/norm(w);
         la = v'*A*v;
      end
end

         