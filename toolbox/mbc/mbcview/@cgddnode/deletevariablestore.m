function obj = deletevariablestore(obj, storekey, exceptions)
%DELETEVARIABLESTORE Remove specifed stores from all variables
%
%  OBJ = DELETEVARIABLESTORE(OBJ, STOREKEY) iterates over all of the
%  variables and removes the store specified by STOREKEY.
%
%  OBJ = DELETEVARIABLESTORE(OBJ, STOREKEY, VAREXCEPTIONS) excludes the
%  variables listed in the xregpointer vector VAREXCEPTIONS from the
%  deletion process.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:23:13 $ 

if nargin>2
    varptrs = setdiff(obj.ptrlist, exceptions);
else
    varptrs = obj.ptrlist;
end
passign(varptrs, pveceval(varptrs, @removestore, storekey));