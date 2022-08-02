function optim = mapptr(optim,RefMap);
%MAPPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:53:46 $

optim.values=mapptr(optim.values,RefMap);
optim.objectiveFuncs=mapptr(optim.objectiveFuncs,RefMap);
optim.constraints=mapptr(optim.constraints,RefMap);
optim.oppoints=mapptr(optim.oppoints,RefMap);

for i = 1:length(optim.oppointValues)
    optim.oppointValues{i} = mapptr(optim.oppointValues{i},RefMap);
end

optim.outputColumns = mapptr(optim.outputColumns,RefMap);
optim.outputWeightsColumns = mapptr(optim.outputWeightsColumns,RefMap);