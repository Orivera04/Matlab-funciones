function obj = modifyvariable(obj, index, varString, varUnit)
%MODIFYVARIABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:12 $


% Ensure that varString is a cell array
if ~iscell(varString)
	varString = {varString};
end

% Have we sent in any units
if nargin < 4
    [varUnit{1:length(index)}] = deal(obj.variables(index).varUnit);
elseif ~iscell(varUnit)
    varUnit = {varUnit};
end

% Iterate through the filters to change
for i = 1:length(index)
    obj.variables(index(i)) = parseVariableString(varString{i}, varUnit{i});
end

% Update the variables from the lowest changed filter
obj = updatevariable(obj, [], min(index));
