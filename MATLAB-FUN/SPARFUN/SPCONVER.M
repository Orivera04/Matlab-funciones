function S = spconvert(D)
%SPCONVERT Convert from sparse external format.
%	S = SPCONVERT(D) converts an nnz or nnz+1 by 3 or 4 array
%	with rows containing [i,j,s] or [i,j,real(s(i,j)),imag(s(i,j))]
%	to the corresponding sparse matrix.  A row of the form [m n 0]
%	or [m n 0 0] anywhere in D may be used to specify size(S).
%	If D is already sparse no conversion is done, so SPCONVERT can
%	be used after D is loaded from either a MAT or an ASCII file.
%
%	See also SPARSE, FULL.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if ~issparse(D)
    [nnz,na] = size(D);
    if na == 3
       S = sparse(D(:,1),D(:,2),D(:,3));
    elseif na == 4
       S = sparse(D(:,1),D(:,2),D(:,3)+i*D(:,4));
    else
       error('Array D must have 3 or 4 columns.')
    end
end
