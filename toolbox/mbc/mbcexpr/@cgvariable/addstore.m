function obj = addstore(obj, storekey, store)
%ADDSTORE Add a new store to a variable
%
%  OBJ = ADDSTORE(OBJ, STOREKEY, STORE) adds the specified store object to
%  the variable, keyed against the given STOREKEY.  If there is a store
%  associated with STOREKEY, this store will be overwritten with the new
%  store object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:16:24 $ 

idx = getIndices(obj.BackupGUIDs, storekey);
if idx == 0
    % Append new store
    obj.BackupValue = [obj.BackupValue, {store}];
    obj.BackupGUIDs = [obj.BackupGUIDs, storekey];
else
    % Overwrite current store with this guid
    obj.BackupValue{idx} = store;
end
