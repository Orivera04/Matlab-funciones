function ok=checknode(nd);
%CHECKNODE  Load-time check of node contents
%
%  OUT=CHECKNODE(ND)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:24:18 $

ok = checknode(nd.cgcontainer);
if ok
    mdlexpr=getdata(nd);
    mdl=mdlexpr.get('model');
    ok = checkmodel(mdl);
end