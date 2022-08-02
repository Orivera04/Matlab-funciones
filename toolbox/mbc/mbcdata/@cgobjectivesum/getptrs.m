function ptrlist=getptrs(obj)
% cgobjectivefunc get xregpointers method
% ptrlist=getptrs(o)
% recursive call to return xregpointers contained within constrain object and all it points to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:39 $

ptrlist = [];
oppoint = obj.oppoint;
if ~isempty(oppoint) & isvalid(oppoint)
    ptrlist=[ptrlist; oppoint; getptrs(oppoint.info); getptrs(obj.cgobjectivefunc)];
end

ptrlist = [ptrlist; getptrs(obj.cgobjectivefunc)];
