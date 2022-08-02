function obj = copyvaluetostore(obj, storekey, datakey)
%COPYVALUETOSTORE Copy current value to a store
%
%  OBJ = COPYVALUETOSTORE(OBJ, STOREKEY, DATAKEY) puts a copy of the
%  current value of OBJ in a store defined by STOREKEY.  Within this store
%  the value is referenced by DATAKEY.
%
%  STOREKEY must be a (1-by-1) guidarray.  DATAKEY can be any item that
%  conforms to the key requirements imposed by the MBCSTORE object.  Note
%  that all DATAKEYs for a given STOREKEY must always be of the same type.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:16:32 $ 

obj = setstorevalue(obj, storekey, datakey, getvalue(obj));