function T = sweepeval(S, f, VarName, Units, Constants);
% SWEEPSET/SWEEPEVAL function evaluation for sweepset
%
% T = sweepfeval(S, F, VARNAME, UNITS, CONSTANTS);
%   Evaluates the function specified in the string F on each sweep in turn
%   Expressions can be any mathematical expression which is supported by the
%   MATLAB INLINE class. All variables used must exist in the sweepset S.
%   The output is a sweepset with Name VARNAME and optional units UNITS
%   and constants CONSTANTS a structure with fields Name and Value

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.2 $ 

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

lasterr;

try
    % Get the sweep sizes
    sweepSizes = tsizes(S);
    sweepStart = tstart(S);
    sweepEnd   = sweepStart + sweepSizes - 1;
    % Precreate the output cell arrays
    newData = cell(length(sweepSizes), 1);
    newDataLength = zeros(size(newData));
    % Convert the input matrix to the correct size cell array with each
    % sweep independent
    InputArgs = mat2cell(S.data(:, varIndex), sweepSizes, ones(size(varIndex)));
    % Need to iterate over the sweeps
    for i = 1:length(sweepSizes)
        % Make sure we have some input args for the inline function
        args = InputArgs(i,:);
        if isempty(args) && isequal(inlineArgs, {'x'})
            args = {[]};
        end
        newData{i} = feval(F, args{:});
        newDataLength(i) = length(newData{i});
    end
    % Concatenate all the sweeps into a single output variable
    newData = cat(1, newData{:});
catch
	error('Unable to evaluate function. Invalid expression or argument');
end

% No variable name specified means return as double rather than sweepset
if nargin < 3 || isempty(VarName)
    T = newData;
    return
end

if nargin < 4
    Units = '?';
end

T = sweepset('variable', 1, 'F5.2', VarName, char(f), Units, 'Transformed Variable', newData );
% If all the sweeps are the same size then replace the original guids
% else if all the new sweeps are of length 1 then the guid should be the input
% sweep guid else we need a new set of guid's
if isequal(newDataLength(:), sweepSizes(:))
    T.guid = S.guid;
elseif all(newDataLength == 1)
    T.guid = getSweepGuids(S);
else
    T.guid = guidarray(length(newData));
end
% Create the new dataset with the new test sizes
T.xregdataset = xregdataset(testnum(S), type(S), newDataLength);
