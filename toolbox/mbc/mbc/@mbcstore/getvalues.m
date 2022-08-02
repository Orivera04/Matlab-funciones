function vals = getvalues(obj, keys, defvalue)
%GETVALUES Return data for multiple keys
%
%  VALS = GETVALUES(OBJ, KEYS, DEFVALUE) returns a vector of data that has
%  been stored for the given keys.  If a key is not found in the store, its
%  value is replaced with the default DEFVALUE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:28 $ 

vals = repmat(defvalue, size(keys));
for n = 1:numel(keys)
    datamatched = (obj.KeyList==keys(n));
    if any(datamatched)
        vals(n) = obj.DataList(datamatched);
    end
end
