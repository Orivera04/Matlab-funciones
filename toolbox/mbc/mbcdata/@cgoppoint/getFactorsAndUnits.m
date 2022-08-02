function names = getFactorsAndUnits(op,fact_i)
%GETFACTORSANDUNITS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:44 $

if nargin<2 | isempty(fact_i)
    fact_i = 1:length(op.ptrlist);
end
names = [];
units = op.units;
factors = get(op,'factors');
for i = 1:length(fact_i)
    names{i} = factors{fact_i(i)};
    if ~isempty(units{fact_i(i)})
        names{i} = [names{i} ' (' char(units{fact_i(i)}) ')'];
    end
end

