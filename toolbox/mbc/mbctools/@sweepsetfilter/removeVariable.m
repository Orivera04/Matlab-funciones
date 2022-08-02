function obj = removevariable(obj, variablesToRemove)
%REMOVEVARIABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:12:08 $

% Logical matrix of 1's of length obj.variables
lVariables = true(1, length(obj.variables));
% Set the filters to remove to be 0
lVariables(variablesToRemove) = false;
% Update the variables field
obj.variables = obj.variables(lVariables);
% Update the object from the least variable changed 
obj = updatevariable(obj, [], min(variablesToRemove));
% Tell everyone that the variables have changed
queueEvent(obj, 'ssfVariablesChanged');
