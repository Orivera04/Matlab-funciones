function tpobj = typeobject(h)
%TYPEOBJECT Return a type object for this node
%
%  TPOBJ = TYPEOBJECT(NODEOBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:38:49 $

persistent H
if isempty(H)
   H = cgtypes.cgtradeofftype;
end

tpobj=H;