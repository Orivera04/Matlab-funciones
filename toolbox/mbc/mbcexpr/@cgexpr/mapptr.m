function v = mapptr(v,RefMap)
%MAPPTR Map pointers method
%
% EXPR = MAPPTR(EXPR,REFMAP) is a non-Recursive call to change any
% instances of pointers in the obejct according to REFMAP.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:09:07 $

v.Inputs = mapptr(v.Inputs, RefMap);