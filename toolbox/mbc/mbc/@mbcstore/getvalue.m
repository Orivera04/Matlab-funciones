function data = getvalue(obj, key)
%GETVALUE Return data for a given key
%
%  DATA = GETVALUE(OBJ, KEY) returns the data that has been stored for a
%  given key.  If the key cannot be found in the object's keylist, data is
%  returned as an empty matrix, [].

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:27 $ 


datamatched = (obj.KeyList==key);
if any(datamatched)
    data = obj.DataList(datamatched);
else
    data = [];
end