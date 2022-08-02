
function cp = crossprod(A)

% Cross product of n-1 vectors from the n-dimensional 
% Euclidean space. They are stored in columns of the matrix A.

[n, m] = size(A);
if n ~= m+1
   error('Number of columns of A must be one less than the number of rows')
end
if rank(A) < min(m,n)
   cp = zeros(n,1);
else 
   C = [ones(n,1) A]';
   cp = zeros(n,1);
   for j=1:n
      cp(j) = cofact(C,1,j);
   end
end

