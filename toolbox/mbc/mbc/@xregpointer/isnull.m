function null = isnull(p)
%ISNULL Check whether pointer is null
%
%  ISNULL(PTR) returns a logical array the same size as ptr which indicates
%  which pointers in ptr are null (do not point to a heap location).  Note
%  that "null" is not the same concept as "valid", which checks whether the
%  heap location being pointed to is still in use or not.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:47:18 $ 

null = (p.ptr==0);
