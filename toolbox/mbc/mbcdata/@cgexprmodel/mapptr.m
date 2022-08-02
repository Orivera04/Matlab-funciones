function m=mapptr(m,RefMap)
% cgExprModel map pointers method
% ptrlist=mapptr(m,RefMap)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:49:44 $


m.allPtrs=mapptr(m.allPtrs,RefMap);
m.modObj=mapptr(m.modObj,RefMap);
m.xregexportmodel=mapptr(m.xregexportmodel,RefMap);
