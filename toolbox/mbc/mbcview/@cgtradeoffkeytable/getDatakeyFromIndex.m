function datakey = getDatakeyFromIndex(obj, Index)
%GETDATAKEYFROMINDEX Return the datakey at a given index
%
%  DATAKEY = GETDATAKEYFROMINDEX(OBJ, INDEX) returns the datakeys at the
%  given list of indices.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:18 $ 

datakey = obj.DataKeyTable(Index, 2);
