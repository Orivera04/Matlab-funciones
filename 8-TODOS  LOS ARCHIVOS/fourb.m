
function [cs, ns, rs, lns] = fourb(A)

% Bases of four fundamental vector spaces associated 
% with the matrix A.
% cs- basis of the column space of A
% ns- basis of the nullspace of A
% rs- basis of the row space of A
% lns- basis of the left nullspace of A

[V, pivot] = rref(A);
r = length(pivot);
cs = A(:,pivot);
ns = null(A,'r');
rs = V(1:r,:)';
lns = null(A','r');

