function [newNames, lChangedNames, nameMap] = generateValidUniqueNames(names)
%GENERATEVALIDUNIQUENAMES make cell array of strings validmlnames and unique
%
%  [NAMES, CHANGES, NAMEMAP] = GENERATEVALIDUNIQUENAMES(NAMES)
%  
%  This function takes a cell array of strings, calls validmlname on each in
%  turn to produce a variable name, then checks for duplicates and
%  modifies them such that the resulting array NAMES is unique. The CHANGES
%  output is a logical array indicating which NAMES have been modified, and
%  the NAMEMAP output is a 2 x N array with the old and new names
%  indicateing what modification has occured. Where duplicate names are
%  found the first instance of the name will be left and all subsequent
%  instances modified

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:20:41 $ 

% To ensure that the leftmost instance of a name is the retained one we
% need to place that at the bottom of the pile
originalSize = size(names);
names = flipud(names(:));
INITIAL_NAMES = names;
% Set up an indicator to names that have been changed
lChangedNames = false(size(names));
% First iterate over the list of names and ensure they are all valid MATLAB
% variable names
[newNames, OK] = validmlname(names);
lChangedNames = ~OK;
% Next make sure there are no duplicates in the array of names
[uniqueNames, i, j] = unique(newNames);
% Test for any duplicates
if length(i) ~= length(j)
    % To find the duplicates in oldNames we look for indicies of uniqueNames
    % into oldNames that are not in the set i. Note this is all duplicates!!
    duplicates = setdiff(1:length(j), i);
    % To find the index of the duplicates in uniqueNames we index into j. Note the
    % sort allows us to group duplicate names together
    [uniqueIndex, k] = sort(j(duplicates));
    % Now iterate through setting the new variable names (invert direction
    % to account for flipud that ensures leftmost variable stay the same)
    lastUniqueIndex = 0;
    for n = length(k):-1:1
        if uniqueIndex(n) ~= lastUniqueIndex
            newFieldTag = 1;
        else
            newFieldTag = newFieldTag + 1;
        end
        % Make sure the new name is unique in the names cell array
        while 1
            uniqueName = [uniqueNames{uniqueIndex(n)} '_' sprintf('%d', newFieldTag)];
            if ~ismember(uniqueName, newNames)
                break
            end
            newFieldTag = newFieldTag + 1;
        end
        % Change the actual name of the variable
        newNames{duplicates(k(n))} = uniqueName;
        lastUniqueIndex = uniqueIndex(n);
    end
    % Update the changed names logical array
    lChangedNames(duplicates) = true;
end
% Default extra output
nameMap = cell(0, 2);
% What about extra outputs?
if nargout > 2 && any(lChangedNames)
    nameMap = [INITIAL_NAMES(lChangedNames) newNames(lChangedNames)];
end
% Reshape everything correctly
lChangedNames = reshape(flipud(lChangedNames), originalSize);
newNames = reshape(flipud(newNames), originalSize);