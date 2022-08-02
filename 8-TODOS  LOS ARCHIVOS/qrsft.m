
function [la, v] = qrsft(A)

% All eigenvalues la of the symmetric matrix A.
% Method used: QR algorithm with Wilkinson's shift.
% Function wsft is used in the body of the function
% qrsft.

[n, n] = size(A);
A = hess(A);
la = [];
i = 0;
while i < n
   [j, j] = size(A);
   if j == 1
      la = [la;A(1,1)];
      return
   end
   mu = wsft(A);
   [Q, R] = qr(A - mu*eye(j));
   A = R*Q + mu*eye(j);
   if abs(A(j,j-1))< 10*(abs(A(j-1,j-1))+abs(A(j,j)))*eps
      la = [la;A(j,j)];
      A = A(1:j-1,1:j-1);
      i = i + 1;
   end
end

