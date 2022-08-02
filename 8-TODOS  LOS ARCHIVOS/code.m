
function B = code(s, A)

% String s is coded using a nonsingular matrix A.
% A coded message is stored in columns of the matrix B.

p = length(s);
[n,n] = size(A);
b = double(s);
r = rem(p,n);
if r ~= 0 
   b = [b zeros(1,n-r)]';
end
b = reshape(b,n,length(b)/n);
B = A*b;
B = B(:)';
