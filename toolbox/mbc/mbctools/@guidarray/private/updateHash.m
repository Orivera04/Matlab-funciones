function obj = updateHash(obj, persistentHashState)
%GUIDARRAY/UPDATEHASH updates the hash info for a GUIDARRAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 
persistent hashState

% Two input arguments allows the obj hashing to be turned on and off
if nargin == 2
    hashState = persistentHashState;
    return
end

% Note the [] is treated as false and hence, by default, hashing is off
if hashState
    [sortedValues, sortedIndex] = sort(obj.values);
    obj.sortedValues = sortedValues;
    obj.sortedIndex  = uint32(sortedIndex);
else
    % Ensure that with hashing off we flag that no hash is stored
    if ~isempty(obj.sortedValues)
        obj.sortedValues = [];
        obj.sortedIndex  = [];
    end
end
