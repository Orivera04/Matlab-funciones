function obj = setvalue(obj, key, data)
%SETVALUE Set data with a given key
%
%  OBJ = SETVALUE(OBJ, KEY, DATA) adds DATA to be stored in OBJ and
%  associated with the key KEY.  If KEY is already being used in the object
%  then DATA will replace the current stored data, otherwise DATA will be
%  added at a new key entry.
%
%  OBJ = SETVALUE(OBJ, KEYS, DATA) where KEYS and DATA are vectors of the
%  same length sets DATA for each corresponding key in KEYS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 06:45:33 $ 

if length(key)==1
    datamatched = (obj.KeyList==key);
    if any(datamatched)
        obj.DataList(datamatched) = data;
    else
        if isempty(obj.KeyList)
            obj.KeyList = key;
            obj.DataList = data;
        else
            obj.KeyList = [obj.KeyList, key];
            obj.DataList = [obj.DataList, data];
        end
    end
else
    not_in_obj = false(size(key));
    for n = 1:length(key)
        datamatched = (obj.KeyList==key(n));
        if any(datamatched)
            obj.DataList(datamatched) = data(n);
        else
            not_in_obj(n) = true;
        end
    end
    if any(not_in_obj)
        key = key(:).';
        data = data(:).';
        if isempty(obj.KeyList)
            obj.KeyList = key(not_in_obj);
            obj.DataList = data(not_in_obj);
        else
            obj.KeyList = [obj.KeyList, key(not_in_obj)];
            obj.DataList = [obj.DataList, data(not_in_obj)];
        end
    end
end