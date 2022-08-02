function [Q,R] = qrinsert(Q,R,j,x)
%QRINSERT Insert a column in the QR factorization.
%	If [Q,R] = qr(A) is the original QR factorization of A,
%	then [Q,R] = qrinsert(Q,R,j,x) changes Q and R to be the
%	factorization of the matrix obtained by inserting an extra
%	column, x, before A(:,j).  (If A has n columns and j = n+1,
%	then x is inserted after the last column of A.)
%
%	See also QR, QRDELETE, PLANEROT.

%	C.B.Moler 5/1/92.  Revised ACWG 6/15/92, CBM 9/11/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(R);
if n == 0
	[Q,R] = qr(x);
	return;
end
% Make room and insert x before j-th column.
R(:,j+1:n+1) = R(:,j:n);
R(:,j) = Q'*x;
n = n+1;

% Now R has nonzeros below the diagonal in the j-th column,
% and "extra" zeros on the diagonal in later columns.
%    R = [x x x x x
%         0 x x x x
%         0 0 + x x
%         0 0 + 0 x
%         0 0 + 0 0]
% Use Givens rotations to zero the +'s, one at a time, from bottom to top.

for k = m-1:-1:j
   p = k:k+1;
   [G,R(p,j)] = planerot(R(p,j));
   if k < n
      R(p,k+1:n) = G*R(p,k+1:n);
   end
   Q(:,p) = Q(:,p)*G';
end
