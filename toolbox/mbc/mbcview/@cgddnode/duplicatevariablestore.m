function obj = duplicatevariablestore(obj, oldstorekey, newstorekey)
%DUPLICATEVARIABLESTORE Duplicate a specified store in all variables
%
%  OBJ = DUPLICATEVARIABLESTORE(OBJ, OLDSTOREKEY, NEWSTOREKEY) iterates
%  over all of the variables and in each one duplicates the store
%  OLDSTOREKEY to create a new store matched against NEWSTOREKEY.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:23:15 $ 

varptrs = obj.ptrlist;
passign(varptrs, pveceval(varptrs, @duplicatestore, oldstorekey, newstorekey));