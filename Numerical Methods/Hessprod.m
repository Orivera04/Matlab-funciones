

function C = Hessprod(A, B)

% Product C=A*B, where A and B are lower and upper 
% Hessenberg matrices, respectively.

[m, n] = size(A);
C = zeros(n);
for i=1:n
   for j=1:n
      if( j<n )
         l = min(i,j)+1;
      else
         l = n;
      end
         C(i,j) = A(i,1:l)*B(1:l,j);
      end
   end
   
   