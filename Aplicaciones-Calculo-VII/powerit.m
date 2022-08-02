
function [la, v] = powerit(A, v)

% Power iteration with the Rayleigh quotient.
% Vector v is the initial estimate of the eigenvector of A.
% Computed eigenvalue la and the associated eigenvector v 
% are such that norm(A*v - la*v,1) < tol, where 
% tol = length(v)*norm(A,1)*eps.

if norm(v) ~= 1
   v = v/norm(v);
end
la = v'*A*v;
tol = length(v)*norm(A,1)*eps;
while norm(A*v - la*v,1) >= tol
   w = A*v;
   v = w/norm(w);
   la = v'*A*v;
end
