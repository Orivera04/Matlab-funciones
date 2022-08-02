function array = getGroupArray(obj, groups);
%GUIDARRAY/GETGROUPARRAY returns a GUIDARRAY that defines the grouping

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $ 

% First check that the groups sum to the size of the guidarray
if sum(groups) ~= length(obj.values)
    error('mbc:guidarray:InvalidArgument', 'The requested groups length (%d) is not equal to the guidarray length (%d)', sum(groups), length(obj.values));
end

% If groups isn't an uint32 then convert
if ~isa(groups, 'uint32')
    groups = uint32(groups);
end

% Create empty guidarray
array = guidarray;

% Call private function to generate the new guids
array.values = getGuidGroups(obj.values, groups);

% What if groups(i) was zero?
zeroGroups = groups == 0;
array.values(zeroGroups) = GetGUID(sum(zeroGroups));

% Hash up output
array = updateHash(array);