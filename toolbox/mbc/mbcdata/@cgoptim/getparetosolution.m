function [data, str, pItems] = getparetosolution(optim, N)
%GETPARETOSOLUTION Return a single pareto optimization solution
%
%  [DATA, COLHEADS, PITEMS] = GETPARETOSOLUTION(OPTIM, NSOL) returns a 2D
%  matrix containing data for pareto solution number NSOL from the
%  optimization. COLHEADS is a cell array of strings containing the names
%  for each column of data. PITEMS is a pointer vector containing the items
%  that each column corresponds to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:53:24 $ 

if N>0 && N<=size(optim.outputData,1)
    data = permute(optim.outputData(N,:,:), [3 2 1]);
    pItems = optim.outputColumns;
    str = pveceval(pItems, 'getname');
else
    error('mbc:cgoptim:InvalidIndex', 'Pareto solution number out of bounds.');
end