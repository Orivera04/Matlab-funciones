
function [S, G] = symmat(A)

% Function symmat takes a 2-by-2 matrix A and
% computes a symmetric 2-by-2 matrix S. Matrices
% A, S, and G satisfy the equation G*A = S, where G 
% is the Givens plane rotation.

if( A(1,2) == A(2,1) )
   S = A;
   G = eye(2);
   return
end
t = (A(1,1) + A(2,2))/(A(1,2) - A(2,1));
s = 1/sqrt(1 + t^2);
c = -t*s;
G(1,1) = c;
G(2,2) = c;
G(1,2)= s;
G(2,1) = -s;
S = G*A;

