function P=mapptr(P,RefMap)
% cgOpPoint map xregpointers method
% opPoint=mapptr(opPoint,oldptr,newptr)
% Non-Recursive call to change any instances of oldptr contained in this object to newptr

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:52:09 $


P.ptrlist=mapptr(P.ptrlist,RefMap);
P.linkptrlist=mapptr(P.linkptrlist,RefMap);
