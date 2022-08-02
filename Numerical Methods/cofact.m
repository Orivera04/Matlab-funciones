
function ckl = cofact(A,k,l)

% Cofactor ckl of the a_kl entry of the matrix A.

[m,n] = size(A);
if m ~= n
   error('Matrix must be square')
end

B = A([1:k-1,k+1:n],[1:l-1,l+1:n]);
ckl = (-1)^(k+l)*det(B);