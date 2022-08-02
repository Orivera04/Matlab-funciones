function ptrlist=getptrsnomod(obj)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:23 $

ptrlist = [];
modptr = obj.modptr;
if ~isempty(modptr) & isvalid(modptr)
    ptrlist=[ptrlist; getptrsnomod(modptr.info)];
end
