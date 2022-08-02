function m=mapptr(m,RefMap)
%MAPPTR  cgmodexpr map xregpointers method
%
%  m=mapptr(m,RefMap)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:20 $

m.cgexpr = mapptr(m.cgexpr, RefMap);
m.model = mapptr(m.model, RefMap);