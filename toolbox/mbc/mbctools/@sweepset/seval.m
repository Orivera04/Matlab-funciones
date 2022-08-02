function T = feval(S, f, VarName, Units, Constants);
% SWEEPSET/FEVAL function evaluation for sweepset
%
% T=feval(S, F, VARNAME, UNITS, CONSTANTS);
%   Evaluates the function specified in the string F
%   Expressions can be any mathematical expression which is supported by the
%   MATLAB INLINE class. All variables used must exist in the sweepset S.
%   The output is a sweepset with Name VARNAME and optional units UNITS
%   and constants CONSTANTS a structure with fields Name and Value

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



% -------------------------------------------------------------------------
% New SWEEPSET/SEVAL code assumes that variable names in the sweepset are
% valid MATLAB names and hence none of this name searching is necassary,
% since the inline function will just parse it correctly for us
% -------------------------------------------------------------------------
% </BEGIN OLD CODE>
% % Need to find sweepset variables in the input string f so ...
% % Get the names of the variables in the sweepset
% names = get(S, 'name');
% % Note that the sweepset names need to be ordered longest first to avoid
% % name clashes such as GAMMA and AM.
% len = cellfun('length', names);
% [len,varNums] = sort(len);
% validIndex = find(flipud(len) <= length(f));
% varNums = flipud(varNums);
% names = names(varNums);
% % Copy the evaluation string for modification
% inlineString = f;
% expressionString = f;
% index = 0;
% varIndex = [];
% % Iterate over each variable name
% for i = validIndex'
% 	if findstr(f, names{i}) & length(f) >= length(names{i});
% 		% If we find the sweepset variable name in the string then
% 		% generate an alias variable of the form ' zN' where N in increasing from 0
% 		varString = [' z' num2str(index) ' '];
% 		index = index + 1;
% 		% Remember the indicies of used variables
% 		varIndex(index) = varNums(i);
% 		% And replace the variable name with ' zN' except where the variable
% 		% is already called 'z' in which case just leave it
% 		f = strrep(f, names{i}, '');
% 		if ~strcmp(names{i}, 'z')
% 			inlineString = strrep(inlineString, names{i}, varString);
% 		else
% 			% In the special case of variable 'z' we need to move its varNum to the
% 			% front of the varIndex queue so that it is passed first into the eval
% 			varIndex = varIndex([end 1:end-1]);
% 		end
% 	end
% end
% 
% F = vectorize(inline(inlineString));
% 
% InputArgs= num2cell(S.data(:,varIndex),1);
% % Make sure we have some input args for the inline function
% if isempty(InputArgs)
% 	InputArgs = {[]};
% end
% </END OLD CODE>

% Allow the input expression to be an inline object
if isa(f, 'inline')
    F = f;
else
    % Inline the expression
    F = vectorize(mbcinline(f));
end
% Get the argument names from the expression
inlineArgs = argnames(F);
% Find the varIndex from the argument names
varIndex = find(S, inlineArgs);

InputArgs = num2cell(S.data(:,varIndex),1);

% Make sure we have some input args for the inline function like f = 14
% (default variable name is x). NOTE this may fail when someone uses a
% variable named x
if isempty(InputArgs) && isequal(inlineArgs, {'x'})
	InputArgs = {[]};
end

lasterr;
try
	% Ensure that TransData is of the correct size
	TransData = S.data(:,1);
	TransData(:) = feval(F, InputArgs{:});
catch
	error('Unable to evaluate function. Invalid expression or argument');
end

% No variable name specified means return as double rather than sweepset
if nargin < 3 || isempty(VarName)
    T = TransData;
    return
end

if all(size(TransData) == [size(S,1),1])
	if nargin < 4
		Units = '?';
	end
% 	T = sweepset('variable',1,'F5.2',VarName,expressionString,Units,'Transformed Variable',TransData );
	T = sweepset('variable', 1, 'F5.2', VarName, char(f), Units, 'Transformed Variable', TransData );
    % Need to replace the guidarray with that from S for traceability
    T.guid = S.guid;
	T.xregdataset = S.xregdataset;
else
	error('Invalid Transformation')
end
