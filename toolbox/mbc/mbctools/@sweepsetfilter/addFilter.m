function obj = addFilter(obj, filterString)
%ADDFILTER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:28 $

% Parse the string into the internal format
obj.filters(end+1) = parseFilterString(filterString);

% Update the filter cache, but updateing on the last filter only
obj = updateFilter(obj, [], length(obj.filters));
