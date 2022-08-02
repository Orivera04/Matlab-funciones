function ptrlist = getptrsnomod(LT);
%GETPTRSNOMOD Return object's pointers
%
%  PTRS = GETPTRSNOMOD(OBJ) is a recursive call to return pointers
%  contained in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:40 $

ptrlist = getptrsnomod(LT.cglookup);
if ~isempty(LT.Xexpr)
    if isvalid(LT.Xexpr)
        ptrlist = [ptrlist;LT.Xexpr; LT.Xexpr.getptrsnomod];
    end
end
if ~isempty(LT.Yexpr)
    if isvalid(LT.Yexpr)
        ptrlist = [ptrlist;LT.Yexpr ; LT.Yexpr.getptrsnomod];
    end
end