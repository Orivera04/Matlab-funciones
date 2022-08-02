function units = getUnitsAsChar(ss)


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:06:21 $

% Set up the output cell array of units
units = cell(ss.nvar, 1);
for i = 1:ss.nvar
    units{i} = char(ss.var(i).units);
end