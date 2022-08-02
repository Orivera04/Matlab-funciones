function [obj, copydone] = duplicatestore(obj, storekey, newstorekey)
%DUPLICATESTORE A short description of the function
%
%  [OBJ, COPYDONE] = DUPLICATESTORE(OBJ, STOREKEY, NEWSTOREKEY) duplicates
%  the store associated with STOREKEY and associates the copy with
%  NEWSTOREKEY.  COPYDONE returns true if a store was found for STOREKEY
%  and the copy happened, false otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:16:34 $ 

idx = getIndices(obj.BackupGUIDs, storekey);
if idx > 0
    obj.BackupValue = [obj.BackupValue, obj.BackupValue(idx)];
    obj.BackupGUIDs = [obj.BackupGUIDs, newstorekey];
else
    copydone = false;
end