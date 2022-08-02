function obj = makeArrayUnique(obj)
%GUIDARRAY/MAKEVALUESUNIQUE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.2 $ 

% First get the sorted values and indicies
[sortedValues, sortedIndex] = sort(obj.values);

% TODO - could update the hash info here - only if no duplicates are found

duplicateValues = false(length(sortedValues), 1);
numDuplicates = 0;
% Iterate through the sortedValues looking for pairings
for i = 2:length(sortedValues)
    % Do we have a duplicate
    if sortedValues(i) == sortedValues(i-1)
        duplicateValues(i) = true;
        numDuplicates = numDuplicates + 1;
    end
end

% What to do with duplicates
if numDuplicates > 0
    % Post a warning that we are changing some GUID's
    warning('mbc:guidarray:NonUniqueGuid', 'Replacing non-unique GUID''s with new values');
    % And modify the second occurence of any duplicates
    obj.values(sortedIndex(duplicateValues)) = GetGUID(numDuplicates);
end

