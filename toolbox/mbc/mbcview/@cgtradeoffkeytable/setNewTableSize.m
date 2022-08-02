function obj = setNewTableSize(obj, sz, oldindex, newindex)
%SETNEWTABLESIZE Alter the table size used to create the table column keys
%
%  SETNEWTABLESIZE(OBJ, SZ) changes the table dimensions that are used to
%  form a linear index key from the multi-dimensional cell indices.  All
%  current table links are destroyed in this process.
%
%  SETNEWTABLESIZE(OBJ, SZ, OLDINDEX, NEWINDEX) allows you to specify a
%  remapping for the old table links.  OLDINDEX and NEWINDEX are lists of
%  linear indices of matching cells in the old and new table sizes.  Any
%  table links that are found in OLDINDEX are mapped to the values in
%  NEWINDEX.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:29 $ 

obj.TableSize = sz;
if ~isempty(obj.DataKeyTable)
    if nargin>2
        [domap, idx] = ismember(obj.DataKeyTable(:,1), oldindex);
        if any(domap)
            obj.DataKeyTable(domap,1) = newindex(idx);
        end
        % unlink all other points
        obj.DataKeyTable(~domap,1) = uint32(0);
    else
        obj.DataKeyTable(:, 1) = uint32(0);
    end
end
