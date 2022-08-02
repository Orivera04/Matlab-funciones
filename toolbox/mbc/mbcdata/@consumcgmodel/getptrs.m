function ptrlist=getptrs(obj)
% GETPTRS consumcgmodel getptrs method
%
%  PTRLIST=GETPTRS(obj)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:56:12 $

ptrlist = [];
modptr = obj.modptr;
pOp = obj.oppoint;
if ~isempty(modptr) & isvalid(modptr)
    ptrlist=[ptrlist; modptr; getptrs(modptr.info)];
end
if ~isempty(pOp) & isvalid(pOp)
    ptrlist=[ptrlist;pOp; getptrs(pOp.info)];
end

