function V = del2(U)
%DEL2	Five-point discrete Laplacian.
%	V = del2(U) is a matrix the same size as U with each element
%	equal to the difference between an element of U and the average
%	of its four neighbors.  For the "corners" and "edges", only two
%	or three neighbors are used.
%
%	See also GRADIENT, DIFF.

%	C. Moler, 7-19-91, 2-1-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[p,q] = size(U);
e = [2:q q];
w = [1 1:q-1];
n = [1 1:p-1]';
s = [2:p p]';

% Interior
V = 0.25*(U(n,:) + U(s,:) + U(:,e) + U(:,w)) - U;

% Edges
V(1,:) = 0.5*(U(1,e) + U(1,w)) - U(1,:);
V(p,:) = 0.5*(U(p,e) + U(p,w)) - U(p,:);
V(:,1) = 0.5*(U(n,1) + U(s,1)) - U(:,1);
V(:,q) = 0.5*(U(n,q) + U(s,q)) - U(:,q);

% Corners
if p > 1 & q > 1
   V(1,1) = 0.5*(V(1,2) + V(2,1));
   V(1,q) = 0.5*(V(1,q-1) + V(2,q));
   V(p,1) = 0.5*(V(p,2) + V(p-1,1));
   V(p,q) = 0.5*(V(p,q-1) + V(p-1,q));
end
