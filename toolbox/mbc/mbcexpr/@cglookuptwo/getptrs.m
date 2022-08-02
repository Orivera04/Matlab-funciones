function ptrlist = getptrs(LT);
%GETPTRS Return pointers in object
%
%  PTRS = GETPTRS(LT) is a recursive call to return pointers contained in
%  this object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:39 $

ptrlist = getptrs(LT.cglookup);
P=LT.Xexpr;
if ~isempty(P)
   ptrlist = [ptrlist; P; getptrs(info(P))];
end
P=LT.Yexpr;
if ~isempty(P)
   ptrlist = [ptrlist; P ; getptrs(info(P))];
end