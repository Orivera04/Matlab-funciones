function [B,i] = ddom(A, tol)
% B = ddom(A) returns a diagonally
% dominant matrix B by modifying the
% diagonal of A.

if (nargin == 1)
    tol = 100 * eps ;
end

d = diag(A) ;
a = abs(d) ;
f = sum(abs(A), 2) - a ;
i = find(f >= a) ;
[m n] = size(A) ;
k = i + (i-1)*m ;
tol = 100 * eps ;
s = 2 * (d(i) >= 0) - 1 ;
A(k) = (1+tol) * s .* max(f(i), tol) ;

B = A ;
