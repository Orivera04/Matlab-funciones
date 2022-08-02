function [LU, guid] = newsizelock(LU)
%NEWSIZELOCK Add and return a new size lock on the table
%
%  [OBJ, GUID] = NEWSIZELOCK(OBJ) create a new size locking key, adds it the
%  object as a lock and returns the new key in GUID.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:26 $ 

guid = guidarray(1);
LU = addsizelock(LU, guid);