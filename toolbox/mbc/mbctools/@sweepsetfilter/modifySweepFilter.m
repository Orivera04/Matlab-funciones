function obj = modifySweepFilter(obj, index, filterString)
%SWEEPSETFILTER/MODIFYSWEEPFILTER modifies some sweep filters

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:09:09 $

% Ensure that filterString is a cell array
if numel(index) == 1
	filterString = {filterString};
end

% Iterate through the filters to change
for i = 1:length(index)
    obj.sweepFilters(index(i)) = parseFilterString(filterString{i});
end

% Update the filters
obj = updateSweepFilters(obj, [], index);