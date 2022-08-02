function idx = convertTableToListIndex(obj, varargin)
%CONVERTTABLETOLISTINDEX Convert table index to correxponding list index
%
%  IDX = CONVERTTABLETOLISTINDEX(OBJ, ROW, COL, ...) converts the table
%  cell indices (ROW, COL, ...) into the corresponding index in the saved
%  inputs list, IDX.  If the table cell is not found in the saved inputs
%  list, an index of 0 is returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:21 $ 

idx = getIndexFromTable(obj.DataKeyTable, varargin{:});
