function obj = removevalue(obj, key)
%REMOVEVALUE  Remove a stored value given a key
%
%  OBJ = REMOVEVALUE(OBJ, KEY) removes the data associated with KEY from
%  the object.  If KEY cannot be found in the object then no operation
%  occurs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:32 $ 

datamatched = (obj.KeyList==key);
if any(datamatched)
    obj.KeyList(datamatched) = [];
    obj.DataList(datamatched) = [];
end