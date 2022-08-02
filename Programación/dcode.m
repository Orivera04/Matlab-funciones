
function s = dcode(B, A)

% Coded message, stored in in columns of the matrix B, is 
% decoded with the aid of the nonsingular matrix A.

[n,n]= size(A);
p = length(B);
B = reshape(B,n,p/n);
d = A\B;
s = char(d(:)');