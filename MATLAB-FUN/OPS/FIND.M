%FIND	Find indices of the non-zero elements.
% 	I = FIND(X) returns the indices of the vector X that are
% 	non-zero. For example, I = FIND(A>100), returns the indices
% 	of A where A is greater than 100. See RELOP.
% 
% 	[I,J] = FIND(X) returns the row and column indices of
% 	the nonzero entries in the matrix X.  This is often used
% 	with sparse matrices.
% 
% 	[I,J,V] = FIND(X) also returns a column vector of the
% 	nonzero entries in X.  Note that find(X) and find(X~=0)
% 	will produce the same I and J, but the latter will produce
% 	a V with all 1's.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
