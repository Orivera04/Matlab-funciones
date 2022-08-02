function outString = updateExpression(inString, nameMap)
%UPDATEEXPRESSION

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:11:54 $ 

oldNames = nameMap(:, 1);
newNames = nameMap(:, 2);
% Note that the sweepset names need to be ordered longest first to avoid
% name clashes such as GAMMA and AM.
% Sort longest to shortest
[oldNames, sortedIndex, sortedLength] = i_sortByLength(oldNames);
% Find valid names (less than the length of the input string)
validIndex = find(sortedLength <= length(inString));
% Reorder the replacement strings 
newNames = newNames(sortedIndex);
dummyNames = cell(size(oldNames));

% Copy the evaluation string for modification
outString = inString;
tempTagIndex = 0;

% Use an identifier that is unlikely to occur in variables and expressions
dummyIdentifier = '¬';
% Iterate over each variable name and see if it needs replacing with a
% dummy variable name
for i = validIndex'
	if ~isempty(findstr(inString, oldNames{i})) && length(inString) >= length(oldNames{i})
		% If we find the sweepset variable name in the string then
		% generate an alias variable of the form dummyIdentifierN where N in increasing from 0
        % Need to ensure this name is not already used in the sweepset in
        % question
        while 1
            dummyName = [dummyIdentifier num2str(tempTagIndex)];
            tempTagIndex = tempTagIndex + 1;
            if ~ismember(dummyName, oldNames)
                break
            end
        end
        % Put spaces around the name
		dummyName = [' ' dummyName ' '];
		% And replace the variable name with dummyIdentifier except where the variable
		% is already called dummyIdentifier in which case just leave it
		inString = strrep(inString, oldNames{i}, '');
		if ~strcmp(oldNames{i}, dummyIdentifier)
			outString = strrep(outString, oldNames{i}, dummyName);
        else
            dummyName = dummyIdentifier;
        end
        % List the dummyIdentifiers that need replacing
        dummyNames{i} = dummyName;
	end
end

% Sort the dummy names on order
[dummyNames, sortedIndex, sortedLength] = i_sortByLength(dummyNames);
% Only iterate over names greater than 0
validIndex = find(sortedLength > 0);
if ~isempty(validIndex)
    % Reindex the newNames
    newNames = newNames(sortedIndex);   
    % Now itereate and replace the dummies with the new names
    for i = validIndex'
        outString = strrep(outString, dummyNames{i}, newNames{i});
    end
end

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function [sortedStrings, sortedIndex, sortedLength] = i_sortByLength(strings)
[sortedLength, sortedIndex] = sort(cellfun('length', strings));
% Flip to longest to shortest
sortedLength = flipud(sortedLength);
sortedIndex = flipud(sortedIndex);
sortedStrings = strings(sortedIndex);
