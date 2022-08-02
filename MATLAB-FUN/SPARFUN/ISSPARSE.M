function t = issparse(S);
%ISSPARSE True if matrix is sparse.
%	ISSPARSE(S) is 1 if the storage class of S is sparse
%	and 0 otherwise.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

t = sparsfun('issparse',S);
