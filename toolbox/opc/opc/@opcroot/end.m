function endval = end(obj,k,n)
%END Last index in an indexing expression of OPC Toolbox array.
%
%    END(A,K,N) is called for indexing expressions involving the 
%    object A when END is part of the K-th index out of N indices.
%

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:06:34 $

if n==1
    endval = length(obj);
else
    sz = size(obj);
    if (k>sz) % if the index is greater than the object's dimensions
        endval = 1;
    else % else return the size of the desired index.
        endval = sz(k);
    end
end