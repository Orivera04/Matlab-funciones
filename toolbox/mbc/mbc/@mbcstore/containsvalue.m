function key_exists = containsvalue(obj, key)
%CONTAINSVALUE Check whether the object contains an entry for a key
%
%  EXISTS = CONTAINSVALUE(OBJ, KEY) returns true if the object contains an
%  entry for KEY.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:25 $ 


key_exists = any(obj.KeyList==key);