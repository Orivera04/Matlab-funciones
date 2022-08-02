function optim = initselectedsolution(optim, Nsol)
%INITSELECTEDSOLUTION Initialize selected solution
%
%  OPTIM = INITSELECTEDSOLUTION(OPTIM, SOLUTION) initializes the selected
%  solution to be SOLUTION for all operating points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:41 $ 
optim.outputSelection = initsol(optim.outputSolution, Nsol, size(optim.outputData,1));