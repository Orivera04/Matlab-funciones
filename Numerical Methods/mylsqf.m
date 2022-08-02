
function x = mylsqf(A, b, f, p)

% The least squares solution x to the overdetermined
% linear system Ax = b using the QR factorization.
% The input parameter f is the string holding the 
% name of a function used to obtain the QR factorization.
% Fourth input parameter p is optional and should be
% set up to 0 if the reduced form of the qr function
% is used to obtain the QR factorization.

[m, n] = size(A);
if m <= n
   error('System is not overdetermined')
end
if nargin == 4
   [Q, R] = qr([A b],0);
else
   [Q, R] = feval(f,[A b]);
end
Qb = R(1:n,n+1);
R = R(1:n,1:n);
x = R\Qb;
