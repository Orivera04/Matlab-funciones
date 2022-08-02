function ptrlist = getptrsnosf(LT);
%GETPTRSNOSF Return object's pointers
%
%  PTRS = GETPTRSNOSF(OBJ) is a recursive call to return pointers contained
%  in this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:41 $

ptrlist = getptrsnosf(LT.cglookup);
if ~isempty(LT.Xexpr)
    if isvalid(LT.Xexpr)
        ptrlist = [ptrlist;LT.Xexpr; LT.Xexpr.getptrsnosf];
    end
end
if ~isempty(LT.Yexpr)
    if isvalid(LT.Yexpr)
        ptrlist = [ptrlist;LT.Yexpr ; LT.Yexpr.getptrsnosf];
    end
end