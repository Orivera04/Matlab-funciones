

function [U, S, V] = mysvd(A)

% Function mysvd computes the singular value decomposition
% of a 2-by-2 real matrix A, i.e., A = U*S*V'. Matrices U 
% and V are orthogonal. The left and the right singular 
% vectors of A are stored in columns of matrices U and V, 
% respectively. Singular values of A are the stored, in the
% descending order, on the main diagonal of the diagonal 
% matrix S.

if A == zeros(2)
   S = zeros(2);
   U = eye(2);
   V = eye(2);
   return
end
[S, G] = symmat(A);
[S, J] = diagmat(S);
U = G'*J;
V = J;
d = diag(S);
s = sign(d);
for j=1:2
   if s(j) < 0
      U(:,j) = -U(:,j);
   end
end
d = abs(d);
S = diag(d);
if ( d(1) < d(2) )
   d = flipud(d);
   S = diag(d);
   U = fliplr(U);
   V = fliplr(V);
end




   
