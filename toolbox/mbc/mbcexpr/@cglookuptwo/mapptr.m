function LT= mapptr(LT,RefMap)
%MAPPTR Remap internal pointers
% 
% nd= MAPPTR(nd,RefMap);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:55 $

LT.Xexpr = mapptr(LT.Xexpr,RefMap);
LT.Yexpr = mapptr(LT.Yexpr,RefMap);
LT.SFlist = mapptr(LT.SFlist,RefMap);
LT.cglookup = mapptr(LT.cglookup, RefMap);