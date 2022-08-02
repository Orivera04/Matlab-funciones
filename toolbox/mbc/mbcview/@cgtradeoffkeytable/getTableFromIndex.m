function [TableIdx, Exists] = getTableFromIndex(obj, Index)
%GETTABLEFROMINDEX Return the table cells for a given datakey index
%
%  TABLEIDX = GETTABLEFROMINDEX(OBJ, INDEX) returns a cell array containing
%  the table cell indices for each element of INDEX.  TABLEIDX contains a
%  cell for each table dimension, with each cell containing an index vector
%  the same length as INDEX.
%
%  [TABLEIDX, EXISTS] = GETTABLEFROMINDEX(...) also returns a logical
%  vector that indicates whether a table link exists for each requested
%  table cell.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:23 $ 

sz = obj.TableSize;

L = zeros(size(Index));
L(Index>0) = double(obj.DataKeyTable(Index(Index>0), 1));
TableIdx = cell(1, length(sz));
[TableIdx{:}] = ind2sub(sz, L);

if nargout>1
    Exists = (L > 0);
end
