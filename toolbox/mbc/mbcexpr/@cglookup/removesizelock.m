function LU = removesizelock(LU, guid)
%REMOVESIZELOCK Remove a size locking key from the table
%
%  OBJ = REMOVESIZELOCK(OBJ, GUID) removes GUID from the list of keys that
%  are locking the size of the table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:12:09 $ 

if ~isempty(LU.sizelocks)
    idx = getIndices(LU.sizelocks, guid);
    if idx>0
        LU.sizelocks(idx) = [];
    end
end