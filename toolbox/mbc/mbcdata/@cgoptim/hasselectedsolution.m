function out = hasselectedsolution(optim)
%HASSELECTEDSOLUTION Check whether the selected solution exists
%
%  OUT = HASSELECTEDSOLUTION(OPTIM) returns true if the selected solution
%  has been set up.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:39 $ 

out = ~isempty(optim.outputSelection);