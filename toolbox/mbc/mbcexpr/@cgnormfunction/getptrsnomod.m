function ptrlist = getptrsnomod(NF);
%GETPTRSNOMOD Return pointers except those in models
%
%  PTRS = GETPTRSNOMOD(OBJ) is a recursive call to return xregpointers
%  contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:46 $


if isempty(NF.Xexpr);
    ptrlist = getptrsnomod(NF.cglookup);
elseif isvalid(NF.Xexpr)
    ptrlist = [getptrsnomod(NF.cglookup); NF.Xexpr ; NF.Xexpr.getptrsnomod];
else
    ptrlist = getptrsnomod(NF.cglookup);
end



