

function C = prod2t(A, B)

% Product C = A*B of two upper triangular matrices A and B.

[m,n] = size(A);
[u,v] = size(B);
if (m ~= n) | (u ~= v)
   error('Matrices must be square')
end
C = zeros(n);
 for i=1:n
   for j=i:n
       C(i,j) = A(i,i:j)*B(i:j,j);
   end
end