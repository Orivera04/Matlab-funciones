function [data, str, pItems] = getsolution(optim, N, Nop)
%GETSOLUTION Return a single optimization solution
%
%  [DATA, COLHEADS, PITEMS] = GETSOLUTION(OPTIM, NSOL) returns a 2D matrix
%  containing data for solution number NSOL from the optimization. COLHEADS
%  is a cell array of strings containing the names for each column of data.
%  PITEMS is a pointer vector containing the items that each column
%  corresponds to.
%  [DATA, COLHEADS, PITEMS] = GETSOLUTION(OPTIM, NSOL, NOPPOINT) returns a
%  single line of data corresponding to the given solution and operating
%  point.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:53:31 $ 

if nargin<3
    Nop = ':';
end
if N>0 && N<=size(optim.outputData,3)
    data = optim.outputData(Nop,:,N);
    str = pveceval(optim.outputColumns, 'getname');
    pItems = optim.outputColumns;
else
    error('mbc:cgoptim:InvalidIndex', 'Solution number out of bounds.');
end