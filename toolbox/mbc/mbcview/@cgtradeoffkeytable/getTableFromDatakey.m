function [TableIdx, Exists] = getTableFromDatakey(obj, datakey)
%GETTABLEFROMDATAKEY Return the table cells for a given datakey index
%
%  [TABLEIDX, EXISTS] = GETTABLEFROMDATAKEY(OBJ, DATAKEY) returns a cell
%  array containing the table cell indices for each key in DATAKEY.
%  TABLEIDX contains a cell for each table dimension, with each cell
%  containing an index vector the same length as DATAKEY.
%
%  [TABLEIDX, EXISTS] = GETTABLEFROMDATAKEY(...) also returns a logical
%  vector that indicates whether a table link exists for each requested
%  datakey.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:22 $ 

Index = getIndexFromDatakey(obj, datakey);
if nargout==1
    TableIdx = getTableFromIndex(obj, Index);
else
    [TableIdx, Exists] = getTableFromIndex(obj, Index);
end
