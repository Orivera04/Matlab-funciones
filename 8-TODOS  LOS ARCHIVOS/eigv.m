
function [la, V] = eigv(A)

% Eigenvalues la and eigenvectors V of the symmetric 
% matrix A with distinct eigenvalues.

V = [];
[n, n] = size(A);
[Q,T] = schur(A);
la = diag(T);
if nargout == 2
   d = diff(sort(la));
   for k=1:n-1
      if d(k) < 10*eps
         d(k) = 0;
      end
   end
   if ~all(d)
      disp('Eigenvalues must be distinct')
   else
      for k=1:n
         U = T - la(k)*eye(n);
         t = U(1:k,1:k);
         y1 = [];
         if k>1
            t11 = t(1:k-1,1:k-1);
            s = t(1:k-1,k);
            y1 = -t11\s;
         end
         y = [y1;1];
         z = zeros(n-k,1);
         y = [y;z];
         v = Q*y;
         V = [V v/norm(v)];         
      end
   end
end


