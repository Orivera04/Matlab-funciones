
function s = eigsen(A)

% Sensitivity of the eigenvalues of the matrix A.
% Condition number for each eigevalue of A is in
% saved in the vector s.

[n,n] = size(A);
[v1,la1] = eig(A);
[v2,la2] = eig(A');
[d1, j] = sort(diag(la1));
v1 = v1(:,j);
[d2, j] = sort(diag(la2));
v2 = v2(:,j);
s = [];
for i=1:n
   v1(:,i) = v1(:,i)/norm(v1(:,i));
   v2(:,i) = v2(:,i)/norm(v2(:,i));
   s = [s;1/abs(v1(:,i)'*v2(:,i))];
end

