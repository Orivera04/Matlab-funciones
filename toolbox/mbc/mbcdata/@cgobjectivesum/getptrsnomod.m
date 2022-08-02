function ptrlist=getptrsnomod(obj)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:40 $

ptrlist = [];
oppoint = obj.oppoint;
if ~isempty(oppoint) & isvalid(oppoint)
    ptrlist=[ptrlist; oppoint; getptrsnomod(oppoint.info); getptrsnomod(obj.cgobjectivefunc)];
end
