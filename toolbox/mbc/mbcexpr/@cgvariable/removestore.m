function obj = removestore(obj, storekey)
%REMOVESTORE Remove a store from an object
%
%  OBJ = REMOVESTORE(OBJ, STOREKEY) removes the store associated with
%  STOREKEY from the object.  If there is no store currently created for
%  STOREKEY then no operation occurs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:16:55 $ 

idx = getIndices(obj.BackupGUIDs, storekey);
if idx > 0
    obj.BackupValue(idx) = [];
    obj.BackupGUIDs(idx) = [];
end