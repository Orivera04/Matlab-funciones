function obj = modifySweepNote(obj, index, noteExp, noteString, noteColor)
%SWEEPSETFILTER/MODIFYSWEEPNOTE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 08:09:10 $

%   $Revision:

% Ensure that noteExp is a cell array
if ~iscell(noteExp)
	noteExp = {noteExp};
end

% Have we sent in any notes
if nargin < 4
    [noteString{1:length(index)}] = deal(obj.sweepNotes(index).noteString);
elseif ~iscell(noteString)
    noteString = {noteString};
end

% Have we sent in any colors
if nargin < 5
    [noteColor{1:length(index)}] = deal(obj.sweepNotes(index).noteColor);
elseif ~iscell(noteColor)
    noteColor = {noteColor};
end

% Iterate through the notes to change
for i = 1:length(index)
    thisNoteColor = noteColor{i};
    if ~isnumeric(thisNoteColor) | ~isequal(size(thisNoteColor), [1 3])
        thisNoteColor = [1 0 0];
    end
    obj.sweepNotes(index(i)) = parseNoteString(noteExp{i}, noteString{i}, thisNoteColor);
end

% Update the sweep note cache
obj = updateSweepNotes(obj, [], index);
