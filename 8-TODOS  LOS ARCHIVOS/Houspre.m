

function P = Houspre(u, A)

% Product P = H*A, where H is the Householder matrix
% determined by the vector u and A is a matrix.

[n, p] = size(A);
m = length(u);
if m ~= n
   error('Dimensions of u and A must agree')
end
v = u/norm(u);
v = v(:);
P = [];
for j=1:p
   aj = A(:,j);
   P = [P aj-2*v*(v.'*aj)];
end
