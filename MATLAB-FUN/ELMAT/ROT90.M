function B = rot90(A,k)
%ROT90	Rotate matrix 90 degrees.
%	rot90(A) is the 90 degree rotation of m x n matrix A.
%	rot90(A,k) is the k*90 degree rotation of A, k = +-1,+-2,...
%	For example,
%
%	      A = [1 2 3      B = rot90(A) = [ 3 6
%	           4 5 6 ]                     2 5
%	                                       1 4 ]
%
%	mesh(B) then shows a 90 degree counter-clockwise rotation
%	of mesh(A).
%
%	See also VIEW, FLIPUD, FLIPLR.

%	From John de Pillis 19 June 1985
%	Modified 12-19-91, LS.
%	Copyright (c) 1984-94 by The MathWorks, Inc.


[m,n] = size(A);
if nargin == 1
    k = 1;
else
    k = rem(k,4);
    if k < 0
        k = k + 4;
    end
end
if k == 1
    A = A.';
    B = A(n:-1:1,:);
elseif k == 2
    B = A(m:-1:1,n:-1:1);
elseif k == 3
    B = A(m:-1:1,:);
    B = B.';
else
    B = A;
end
