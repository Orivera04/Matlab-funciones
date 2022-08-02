
function Q = Housprod(V)

% Product Q of several Householder transformations
% represented by their reflection vectors saved in
% columns of the matrix V.

[m, n] = size(V);
Q = eye(m)-2*V(:,n)*V(:,n)';
for i=n-1:-1:1
   Q = Houspre(V(:,i),Q);
end
