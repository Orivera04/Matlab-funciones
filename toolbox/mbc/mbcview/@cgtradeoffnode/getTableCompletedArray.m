function isComplete = getTableCompletedArray(obj)
%GETTABLECOMPLETEDARRAY Return logical matrix indicating which table cells are "complete"
%
%  ISCOMPLETE = GETTABLECOMPLETEDARRAY(OBJ) creates a logical matrix the
%  same size as the tables in the tradeoff.  Table cells that have a saved
%  input data key that is marked as having been saved at least once are
%  marked with true values.  If there are no tables in the tradeoff an
%  empty matrix is returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:38 $ 

if numTables(obj)>0
    isComplete = false(obj.Tables(1).getTableSize);
    
    % Find datakeys that have been saved at least once and that have a link
    % to a table cell.
    datakeysComplete = hasTableLink(obj.DataKeyTable) & isPointSaved(obj.DataKeyTable);
    TableIndex = getTableFromIndex(obj.DataKeyTable, find(datakeysComplete));
    LinearIdx = sub2ind(size(isComplete), TableIndex{:});
    isComplete(LinearIdx) = true;
else
    isComplete = false(0,0);
end
