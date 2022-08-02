
function [D, G] = diagmat(A);

% Function diagmat takes a 2-by-2 matrix A and
% returns a diagonal matrix D obtained by 
% application of the two-sided Givens rotation
% to the matrix A. Second output parameter G is
% the Givens rotation used to diagonalize matrix A,
% i.e., G.'*A*G = D.

if ((A==A.')~=ones(size(A)))
   error('Matrix must be symmetric')
end
if ( abs(A(1,2)) < eps & abs(A(2,1)) < eps )
   D = A;
   G = eye(2);
   return
end
r = roots([-1 (A(1,1)-A(2,2))/A(1,2) 1]);
[t, k] = min(abs(r));
t = r(k);
c = 1/sqrt(1+t^2);
s = c*t;
G = zeros(size(A));
G(1,1) = c;
G(2,2) = c;
G(1,2) = s;
G(2,1) = -s;
D = G.'*A*G;
