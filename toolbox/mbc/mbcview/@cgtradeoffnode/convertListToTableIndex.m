function varargout = convertListToTableIndex(obj, idx)
%CONVERTLISTTOTABLEINDEX Convert list index to corresponding table index
%
%  [ROW, COL, ...] = CONVERTLISTTOTABLEINDEX(OBJ, IDX) converts the linear
%  index into the list of saved points, IDX, into the corersponding table
%  cell indices.  If the saved points is not linked to a table cell, all of
%  the returned indices will be zero.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:20 $ 

varargout = getTableFromIndex(obj.DataKeyTable, idx);
