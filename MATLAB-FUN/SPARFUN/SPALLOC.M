function s = spalloc(m,n,nzmax)
%SPALLOC Alloc memory for nonzero entries.
%	s = SPALLOC(m,n,nzmax) creates an m-by-n all zero sparse matrix
%	with room to eventually hold nzmax nonzeros.
%	For example:
%
%	    s = spalloc(n,n,3*n);
%	    for j = 1:n
%	        s(:,j) = (a sparse column vector with 3 nonzero entries);
%	    end
%
%	See also SPONES, SPDIAGS, SPRANDN, SPRANDSYM, SPEYE, SPARSE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

s = sparse([],[],[],m,n,nzmax);
