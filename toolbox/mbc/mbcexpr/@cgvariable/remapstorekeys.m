function obj = remapstorekeys(obj, storekey, olddatakeys, newdatakeys)
%REMAPSTOREKEYS Change the keys that are being used withing a store
%
%  OBJ = REMAPSTOREKEYS(OBJ, STOREKEY, OLD_DATAKEYS, NEW_DATAKEYS) executes
%  a key remapping within the store defined by STOREKEY.  Values in this
%  store are moved from the keys defined in OLD_DATAKEYS to the
%  corresponding key in NEW_DATAKEYS and the old key is removed from the
%  store.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:16:53 $ 


idx = getIndices(obj.BackupGUIDs, storekey);
if idx > 0
    obj.BackupValue{idx} = remapkeys(obj.BackupValue{idx}, olddatakeys, newdatakeys);
end