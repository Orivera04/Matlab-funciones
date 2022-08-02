function [data, str, pItems] = getselectedsolution(optim)
%GETSELECTEDSOLUTION Return solution that has been selected by the user
%
%  [DATA, COLHEADS, PITEMS] = GETSELECTEDSOLUTION(OPTIM) returns the
%  solution at each operating point that has been selected as the best one
%  by the user. COLHEADS is a cell array of strings containing the names
%  for each column of data. PITEMS is a pointer vector containing the items
%  that each column corresponds to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:53:30 $ 

data = getSolutionData(optim.outputSelection, optim.outputData);
pItems = optim.outputColumns;
str = pveceval(pItems, 'getname');