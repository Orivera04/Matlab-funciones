function ptrlist=getptrs(m)
%GETPTRS cgmodexpr get xregpointers method
%
%  PTRLIST = GETPTRS(m) is a recursive call to return xregpointers
%  contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:09 $

ptrlist = getptrs(m.cgexpr);
pModel = getptrs(m.model);
ptrlist = [ptrlist; pModel(:)];
