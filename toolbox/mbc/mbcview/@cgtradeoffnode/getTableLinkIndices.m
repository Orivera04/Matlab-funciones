function varargout = getTableLinkIndices(obj, listindex)
%GETTABLELINKINDICES Get the row/column indices of saved input points
%
%  [ROWS, COLS, ...] = GETTABLELINKINDICES(OBJ, LISTINDEX) returns row and
%  column index vectors for each of the specified saved input points.  If
%  any of the points are not linked to a table cell, they will have a row
%  and column index of 0.  If the LISTINDEX input is omitted, table links
%  for all of the saved input points will be returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:39 $ 

if numTables(obj)>0
    if nargin<2
        listindex = 1:length(obj.DataKeyTable);
    end
    varargout = getTableFromIndex(obj.DataKeyTable, listindex);
else
    if nargin>1
        varargout(1:nargout) = {zeros(length(listindex), 1)};
    else
        varargout(1:nargout) = {zeros(length(obj.DataKeyTable), 1)};
    end
end
