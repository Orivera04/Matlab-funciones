function ptrlist = getptrsnomod(N);
%GETPTRSNOMOD Return pointers except those in models
%
%  PTRS = GETPTRSNOMOD(OBJ) is a recursive call to return xregpointers
%  contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:56 $


if isempty(N.Xexpr);
    ptrlist = getptrsnomod(N.cglookup);
elseif isvalid(N.Xexpr)
    ptrlist = [getptrsnomod(N.cglookup); N.Xexpr ; N.Xexpr.getptrsnomod];
else
    ptrlist = getptrsnomod(N.cglookup);
end