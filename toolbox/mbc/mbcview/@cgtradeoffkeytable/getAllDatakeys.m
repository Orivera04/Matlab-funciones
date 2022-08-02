function datakey = getAllDatakeys(obj)
%GETALLDATAKEYS Return all datakey entries
%
%  GETALLDATAKEYS(OBJ) returns the list of all datakeys currently in the
%  table.  This will be a uint32 vector.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:17 $ 

datakey = obj.DataKeyTable(:,2);
