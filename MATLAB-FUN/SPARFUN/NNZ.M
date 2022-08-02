function nz = nnz(S);
%NNZ   	Number of Nonzeros.
%	nz = NNZ(S) is the number of nonzeros in S.
%
%	See also NONZEROS, SIZE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

nz = sparsfun('nnz',S);
