function tpobj=typeobject(h)
%TYPEOBJECT  Return a type object for this node
%
%  TPOBJ=TYPEOBJECT(NDOEOBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:29:59 $

persistent H
if isempty(H)
   H=cgtypes.cgtabletype;
end

tpobj=H;