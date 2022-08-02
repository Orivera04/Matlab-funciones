function mc= xregcubic(m);
%XREGUNCODEDPOLY/XREGCUBIC convert to coded polynomial

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.6.2 $  $Date: 2004/02/09 08:00:26 $

mc = m.xregcubic;
[Bnds,g,Tgt]= getcode(m);
NewTgt= recommendedTgt(mc);
Tgt(:,1)= NewTgt(1);
Tgt(:,2)= NewTgt(2);

mc= setcode(mc,Bnds,g,Tgt);

