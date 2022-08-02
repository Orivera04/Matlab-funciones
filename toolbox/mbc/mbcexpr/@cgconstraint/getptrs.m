function ptrlist=getptrs(obj)
%GETPTRS Return all pointers from object
%
%  PTRLIST = GETPTRS(OBJ) is a recursive call to return xregpointers
%  contained within constrain object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 07:09:18 $

ptrlist = [getptrs(obj.cgexpr); getptrs(obj.conobj)];