function obj = removeSweepFilter(obj, filtersToRemove)
%SWEEPSETFILTER/REMOVEFILTER removes some sweep filters

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:12:06 $

% Logical true matrix of length obj.sweepFilters
lFilters = true(length(obj.sweepFilters), 1);
% Set the filters to remove to be 0
lFilters(filtersToRemove) = false;
% Update the sweep filters field
obj.sweepFilters = obj.sweepFilters(lFilters);
% Update the object without re-evaluating filters
obj = updateSweepFilters(obj, [], []);
% Tell everyone that the sweep filters have changed
queueEvent(obj, 'ssfSweepFiltersChanged');
