function obj = setvalue(obj, key, data)
%SETVALUE Set data with a given key
%
%  OBJ = SETVALUE(OBJ, KEY, DATA) adds DATA to be stored in OBJ and
%  associated with the key KEY.  If KEY is already being used in the object
%  then DATA will replace the current stored data, otherwise DATA will be
%  added at a new key entry.
%
%  OBJ = SETVALUE(OBJ, KEYS, DATA) where KEYS and DATA are vectors of the
%  same length sets DATA for each corresponding key in KEYS.  Note that in
%  this case, it is not generally correct to attempt to pass in a cell
%  array of dissimilar items with corresponding keys.  Doing this will lead
%  to the values being wrapped internally in an additional cell array. If
%  you require the ability to use vectors of keys with disimilar objects
%  then you should consider using a basic mbcstore and providing the cell
%  array wrapper yourself.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 06:43:58 $ 

if length(key)==1
    obj.mbcstore = setvalue(obj.mbcstore, key, {data});
else
    obj.mbcstore = setvalue(obj.mbcstore, key, num2cell(data));
end