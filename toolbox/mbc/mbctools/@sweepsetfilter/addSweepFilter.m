function obj = addSweepFilter(obj, filterString)
%ADDSWEEPFILTER adds a filter to remove sweeps based on a rule
%
%  OBJ = ADDSWEEPFILTER(OBJ, FILTERSTRING)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $    $Date: 2004/02/09 08:08:31 $ 

% Parse the string into the internal format
obj.sweepFilters(end+1) = parseFilterString(filterString);

% Update the sweep filter cache, but updateing on the last filter only
obj = updateSweepFilters(obj, [], length(obj.sweepFilters));
