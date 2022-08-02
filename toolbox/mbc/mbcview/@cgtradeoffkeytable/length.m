function n = length(obj)
%LENGTH Return number of entries in table
%
%  LENGTH(OBJ) returns the number of datakeys that have been added to the
%  table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:27 $ 

n = size(obj.DataKeyTable, 1);
