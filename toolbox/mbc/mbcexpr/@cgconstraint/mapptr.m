function obj = mapptr(obj,RefMap);
%MAPPTR Pointer remapping method
%
%  OBJ = MAPPTR(OBJ, REFMAP)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 07:09:25 $

obj.conobj = mapptr(obj.conobj,RefMap);
obj.cgexpr = mapptr(obj.cgexpr, RefMap);