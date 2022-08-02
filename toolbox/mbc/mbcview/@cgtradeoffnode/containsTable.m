function in = containsTable(obj, pTable)
%CONTAINSTABLE Check whether tradeoff contains a table
%
%  IN = CONTAINSTABLE(OBJ, PTABLE) returns true for those pointers in
%  PTABLE that point to tables that are already in the tradeoff.  IN is a
%  logical vector the same size as pTable.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:19 $ 


if isempty(obj.Tables)
    in = false(size(pTable));
else
    in = ismember(pTable, obj.Tables);
end
