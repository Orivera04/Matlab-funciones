function LU = addsizelock(LU, guid)
%ADDSIZELOCK Add a new size locking key to the table
%
%  OBJ = ADDSIZELOCK(OBJ, GUID) adds GUId to the list of keys that are
%  locking the size of the table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:09:57 $ 

LU.sizelocks = [LU.sizelocks, guid];