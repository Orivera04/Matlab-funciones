function [sortedValues, sortedIndex] = getHash(obj)
%GUIDARRAY/GETHASH returns the hash informiation for a GUIDARRAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

% This funtion provides an accessor to the hash info such that the sort can
% be turned off a creation time and regenerated when requested. It works in
% conjunction with updateHash, which is called to generate the hash when
% the object is created.

if isempty(obj.sortedValues)
    [sortedValues, sortedIndex] = sort(obj.values);
    sortedIndex = uint32(sortedIndex);
else
    sortedValues = obj.sortedValues;
    sortedIndex  = obj.sortedIndex;
end