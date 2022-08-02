function N = length(obj)
%LENGTH Return number of items in mbcstore
%
%  N = LENGTH(OBJ) returns the number of items being held in the mbcstore
%  OBJ.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:29 $ 

N = length(obj.KeyList);