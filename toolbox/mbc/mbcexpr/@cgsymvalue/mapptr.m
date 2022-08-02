function v=mapptr(v,RefMap)
%MAPPTR map pointers method
% 
%  v = MAPPTR(v,RefMap)
%
%  Non-Recursive call to change any instances of oldptr contained in this
%  object to newptr

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:39 $

v.EquationPointers = mapptr(v.EquationPointers,RefMap);