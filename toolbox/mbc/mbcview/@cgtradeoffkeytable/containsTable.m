function ret = containsTable(obj, varargin)
%CONTAINSTABLE Check whether a table cell exists in the datakey table
%
%  RET = CONTAINSTABLE(OBJ, R, C) returns a logical vector the same length
%  as the number of (R, C) pairs.  This vector indicates which (R, C) pairs
%  exist as table links in the data key table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:16 $ 

L = uint32(sub2ind(obj.TableSize, varargin{:}));
keys = obj.DataKeyTable(:,1);
ret = false(size(L));
for n = 1:numel(L)
    ret(n) = any(L(n)==keys);
end
