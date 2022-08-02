function obj = removeFilter(obj, filtersToRemove)
%REMOVEFILTER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:12:03 $

% Logical true matrix of length obj.filters
lFilters = true(1, length(obj.filters));
% Set the filters to remove to be 0
lFilters(filtersToRemove) = false;
% Update the filters field
obj.filters = obj.filters(lFilters);
% Update the object without re-evaluating the filters
obj = updateFilter(obj, [], []);
% Tell everyone that the filters have changed
queueEvent(obj, 'ssfFiltersChanged');
