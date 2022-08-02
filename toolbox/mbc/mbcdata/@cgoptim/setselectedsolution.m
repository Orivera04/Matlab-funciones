function optim = setselectedsolution(optim, nOp, Nsol)
%SETSELECTEDSOLUTION Set the selected solution for an operating point
%
%  OPTIM = SETSELECTEDSOLUTION(OPTIM, OPPOINT, SOLUTION) sets the selected
%  solution to SOLUTION for the the given operating point, OPPOINT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:57 $ 

if ~isempty(optim.outputSelection)
    optim.outputSelection = setSol(optim.outputSelection, nOp, Nsol);
end