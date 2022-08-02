function [Q,R] = qrdelete(Q,R,j)
%QRDELETE Delete a column from the QR factorization.
%	If [Q,R] = qr(A) is the original QR factorization of A,
%	then [Q,R] = qrdelete(Q,R,j) changes Q and R to be the
%	factorization of the matrix with A(:,j) removed.
%
%	See also QR, QRINSERT, PLANEROT.

%	C.B.Moler 5/1/92.  Revised ACWG 6/15/92, CBM 9/11/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Remove the j-th column.  n = number of columns in modified R.
R(:,j) = [];
[m,n] = size(R);

% R now has nonzeros below the diagonal in columns j through n.
%    R = [x x x x
%         0 x x x
%         0 + x x
%         0 0 + x
%         0 0 0 +]
% Use Givens rotations to zero the +'s, one at a time, from left to right.

for k = j:min(n,m-1)
   p = k:k+1;
   [G,R(p,k)] = planerot(R(p,k));
   if k < n
      R(p,k+1:n) = G*R(p,k+1:n);
   end
   Q(:,p) = Q(:,p)*G';
end
