function ptrlist = getptrs(NF);
%GETPTRS Return pointers from object
%
%	PTRS = GETPTRS(OBJ) is a recursive call to return xregpointers
%	contained in this object and all it points to.
%	For a cgnormfunction the only xregpointer is in the Xexpr field.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:45 $

P=NF.Xexpr;
if ~isempty(P);
   ptrlist = [getptrs(NF.cglookup); P ; getptrs(info(P))];
else
   ptrlist = getptrs(NF.cglookup);
end



