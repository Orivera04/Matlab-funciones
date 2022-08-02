function obj = addvariable(obj, varString, varUnit)
%ADDVARIABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:08:33 $

if nargin < 3
    varUnit = '';
end

f = getFlags;

% Parse the string into the internal format
obj.variables(end+1) = parseVariableString(varString, varUnit);

% Update the object with the last variable
obj = updatevariable(obj, [], length(obj.variables));


