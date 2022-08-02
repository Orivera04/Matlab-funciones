% tri_diag(a,b,c,d,n) solves a tridiagonal equation.
% a, b, c are tridiagonal coefficients, d is the source
% vector, and n is the number of unknowns.
% See Section 11.3. L11_1  Copyright S. Nakamura 1995
function f = tri_diag(a,b,c,d,n)
for i=2:n
   r=a(i)/b(i-1);
   b(i)=b(i)-r*c(i-1);
   d(i)=d(i)-r*d(i-1);
end
d(n)=d(n)/b(n);
for i=n-1:-1:1
   d(i)=(d(i)-c(i)*d(i+1))/b(i);
end
f=d;

