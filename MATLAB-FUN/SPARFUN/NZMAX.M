function nzmx = nzmax(S);
%NZMAX 	Amount of storage allocated for nonzeros.
%	For a sparse matrix, NZMAX(S) is the number of storage locations
%	allocated for the nonzero elements in S.
%	For a full matrix, NZMAX(S) is prod(size(S)).
%	In both cases, nnz(S) <= nzmax(S) <= prod(size(S)).
%
%	See also NNZ, NONZEROS, SPALLOC.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

nzmx = sparsfun('nzmax',S);
