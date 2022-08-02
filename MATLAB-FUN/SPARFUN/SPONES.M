function R = spones(S);
%SPONES	Replace nonzero entries with ones.
%	R = SPONES(S) generates a matrix with the same sparsity
%	structure as S, but with ones in the nonzero positions.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[i,j] = find(S);
[m,n] = size(S);
R = sparse(i,j,1,m,n);
