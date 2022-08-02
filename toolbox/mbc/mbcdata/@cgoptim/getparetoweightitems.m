function ptrs = getparetoweightitems(optim)
%GETPARETOWEIGHTITEMS Return pointers to items that weights are defined at
%
%  PTRS = GETPARETOWEIGHTITEMS(OPTIM) returns a pointer array containing
%  pointers to the objectives that the weight data is being given for.
%  There is an objectives for each column of data returned by
%  GETPARETOWEIGHTS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:25 $ 

ptrs = optim.outputWeightsColumns;