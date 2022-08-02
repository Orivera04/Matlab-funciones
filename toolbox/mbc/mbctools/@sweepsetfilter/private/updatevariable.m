function [obj, ss] = updatevariable(obj, ss, startIndex)
%UPDATEVARIABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:32:07 $

f = getFlags;

% Have we got a current copy of the sweepset
if nargin < 2 || ~isa(ss, 'sweepset')
    ss = ApplyObject(obj, f.APPLY_DATA);
end
% Ensure that startIndex is initialised
if nargin < 3
    startIndex = 1;
end

% Store to see if variables are changed in the update process
INITIAL_variables = obj.variables;

% Reset variableSweepset field before iterating through variables
if startIndex == 1
    obj.variableSweepset = sweepset;
else
    ssEndIndex = startIndex - 1;
    % Need to ensure that all startIndex doesn't include some problem
    % variables. Find those variables which have errors
    for i = 1:ssEndIndex
        if ~obj.variables(i).OK
            ssEndIndex = ssEndIndex - 1;
        end
    end
    obj.variableSweepset = obj.variableSweepset(:, 1:ssEndIndex);
    % Need to append the unchanged variables to the current sweepset
    ss = [ss obj.variableSweepset];
end

% Iterate through all the stored variables
for i = startIndex:length(obj.variables)
	[varOK, value, obj.variables(i)] = i_evaluateVariable(obj.variables(i), ss);
	if varOK
		obj.variableSweepset = [obj.variableSweepset value];
        ss = [ss value];
	end	
end

% Have the variables actually changed
if ~isidentical(obj.variables, INITIAL_variables)
    queueEvent(obj, 'ssfVariablesChanged');
end

% Note we have already appended the new variables to ss in the loop above

% Now cascade the update to filters
[obj, ss] = updateFilter(obj, ss);

%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
function [varOK, value, variable] = i_evaluateVariable(variable, ss)
try
	% Check that the new variable doesn't already exist in pSweepset or variablesToAppend
	if ~isempty(find(ss, variable.varName))
		error('mbc:sweepsetfilter:InvalidArgument', 'Variable name already exists in sweepset');
	end	
	% Evaluate the inline expression    
	value = seval(ss, variable.inlineExp, variable.varName, variable.varUnit);
	variable.result = 'Variable successfully added';
    variable.OK = true;
catch
	err = lasterr;
	% Remove everything up to the first CR and then replace any remaining CR in with spaces
	CRpos = findstr(sprintf('\n'),err);
	if length(CRpos > 1)
		err = err(CRpos(1)+1:end);
	end
	err = strrep(err, sprintf('\n'), '  ');
	variable.result = ['Error : ' err];
    variable.OK = false;
    value = [];
end
varOK = variable.OK;
