function LT = mapptr(LT,RefMap);
%MAPPTR Remap internal pointers
%
%  OBJ = MAPPTR(OBJ, REFMAP)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:10 $

LT.Xexpr = mapptr(LT.Xexpr,RefMap);
LT.SFlist = mapptr(LT.SFlist,RefMap);
LT.Flist = mapptr(LT.Flist,RefMap);
LT.cglookup = mapptr(LT.cglookup, RefMap);