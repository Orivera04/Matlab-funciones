function [data, str, pItems] = getsolutioncube(optim)
%GETSOLUTIONCUBE Return the cube of optimization output data
%
%  [DATA, COLHEADS, PITEMS] = GETSOLUTIONCUBE(OPTIM) returns the 3-D matrix
%  of output data from OPTIM. COLHEADS is a cell array of strings
%  containing the names for each column (2nd dimension) of data. PITEMS is
%  a pointer vector containing the items that each column corresponds to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:53:32 $

if ~isempty(optim.outputData)
    data = optim.outputData;
    str = pveceval(optim.outputColumns, 'getname');
    pItems = optim.outputColumns;
else
    data = [];
    str = {};
    pItems = [];
end
