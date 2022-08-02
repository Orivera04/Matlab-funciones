function ptrlist = getptrs(N);
%GETPTRS Return pointers from object
%
%	PTRS = GETPTRS(OBJ) is a recursive call to return xregpointers
%	contained in this object and all it points to.
%	For a cgnormaliser the xregpointers are in the Xexpr field. To find out
%	the contents of the Flist field use get(N,'Flist').

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:55 $

P=N.Xexpr;
if ~isempty(P);
   ptrlist = [getptrs(N.cglookup); P ; getptrs(info(P))];
else
   ptrlist = getptrs(N.cglookup);
end
