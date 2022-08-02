
function [Q, R] = mgs(A)

% Modified Gram-Schmidt orthogonalization of the
% matrix A = Q*R, where Q is orthogonal and R upper
% is triangular.

[m, n] = size(A);
for i=1:n
   R(i,i) = norm(A(:,i));
   Q(:,i) = A(:,i)/R(i,i);
   for j=i+1:n
      R(i,j) = Q(:,i)'*A(:,j);
      A(:,j) = A(:,j) - R(i,j)*Q(:,i);
   end
end

   