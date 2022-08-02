
function d = mydet(A)

% Determinant d of the matrix A. Function cofact must be
% in MATLAB's search path. 

[m,n] = size(A);
if m ~= n
   error('Matrix must be square')
end
a = A(1,:);
c = [];
for l=1:n
   c1l = cofact(A,1,l);
   c = [c;c1l];
end
d = a*c;
