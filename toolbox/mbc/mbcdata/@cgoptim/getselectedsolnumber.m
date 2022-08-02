function solindex = getselectedsolnumber(optim, rowindex)
%GETSELECTEDSOLNUMBER Return currently selected solution number
%
%  SOL_INDEX = GETSELECTEDSOLNUMBER(OPTIM, OPPOINT_INDEX) returns the
%  number of the solution currently selected for the operating point
%  rowindex.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:29 $ 


if isempty(optim.outputSelection)
    solindex = [];
else
    solindex = getSol(optim.outputSelection, rowindex);
end