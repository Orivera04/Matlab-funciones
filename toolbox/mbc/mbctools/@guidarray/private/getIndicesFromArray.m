function index = getIndicesFromArray(obj, indexer)
%GUIDARRAY/GETINDICESFROMARRAY returns the indicies from indexer in the object obj

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.2 $   $Date: 2004/02/09 08:03:03 $

% Check for empty indexing
if isempty(obj) || isempty(indexer)
    index = zeros(size(indexer));
    return
end

% Check that indexer is a GUIDARRAY
switch class(indexer)
    case 'guidarray'
    otherwise
        error('mbc:guidarray:InvalidArgument', 'The second argument must be a guidarray object');
end

[sortedValues, sortedIndex] = getHash(obj);
% TO DO - Faster find than ismembc2 which makes use of both hash's
% Find indexer values in obj hash table
i = ismembc2(indexer.values, sortedValues);
% Initialise output
index = zeros(length(i), 1);
% Which outputs from ismembc2 are non-zero
NON_ZERO = i > 0;
% Output the real index not the sorted index
index(NON_ZERO) = sortedIndex(i(NON_ZERO));