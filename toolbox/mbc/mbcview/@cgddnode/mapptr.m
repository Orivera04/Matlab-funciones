function nd=mapptr(nd,RefMap)
%MAPPTR  Remap pointers
%
%  ND = MAPPTR(ND, REFMAP)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:23:37 $

nd.ptrlist=mapptr(nd.ptrlist,RefMap);
nd.cgcontainer=mapptr(nd.cgcontainer,RefMap);

