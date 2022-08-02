function obj = vertcat(varargin)
% GUIDARRAY/VERTCAT concatenate GUIDARRAY object together

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $ 


% Remove any built-in emptys first
varargin = varargin(~cellfun('isempty', varargin));
% Is anything left?
if isempty(varargin)
    obj = guidarray;
    return
end

% Holder to calculate the total length of the output object
totalLength = 0;
% First check that all inputs are GUIDARRAY object
for i = 1:length(varargin)
    array = varargin{i};
    if ~isa(array, 'guidarray')
        error('mbc:guidarray:InvalidArgument', 'Input %d for concatenation is not a guidarray object', i);
    end
    totalLength = totalLength + length(array.values);
end

% Create an empty guidarray
obj = guidarray;
% Initialise the values field
obj.values = zeros(totalLength, 1);
% Looper define the current starting point in the array
startPoint = 1;
% Do the concatenation
for i = 1:length(varargin)
    % Array to concatenate
    array = varargin{i};
    endPoint = startPoint + length(array.values) - 1;
    obj.values(startPoint:endPoint) = array.values;
    % TO DO - change this to call a helper mex file which concatenates the
    % 2 hash tables and hence doesn't need a hashUpdate at the end. The
    % call is [OK, s, si] = helper(A, Ai, B, Bi); Then test OK.
    % Next array goes beyond the current
    startPoint = endPoint + 1;
end
% Check the array is unique
obj = makeArrayUnique(obj);
% Update the hash
obj = updateHash(obj);
