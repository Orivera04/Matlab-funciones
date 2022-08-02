function obj = guidarray(arrayLength)
%GUIDARRAY/GUIDARRAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.2 $ 

if nargin < 1
    arrayLength = 0;
end

% Get the GUID's from the private GUID generator
a = GetGUID(arrayLength);
% Hold the GUID values
obj.values = a;

% Space for a hash table of sorted GUID values
obj.sortedValues = [];
obj.sortedIndex  = uint32([]);

% Object version
obj.version = 1;

% Create the object
obj = class(obj, 'guidarray');

% Update the hash table
obj = updateHash(obj);