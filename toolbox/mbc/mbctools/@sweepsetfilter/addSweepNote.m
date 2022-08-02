function obj = addSweepNote(obj, noteExp, noteString, noteColor)
%ADDSWEEPNOTE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 08:08:32 $

%   $Revision:

if nargin < 4 | ~isnumeric(noteColor) | ~isequal(size(noteColor), [1 3])
    noteColor = [1 0 0];
end

% Parse the string into the internal format
obj.sweepNotes(end+1) = parseNoteString(noteExp, noteString, noteColor);

% Update the sweep note cache
obj = updateSweepNotes(obj, [], length(obj.sweepNotes));

