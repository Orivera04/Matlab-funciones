function obj = removeSweepNote(obj, notesToRemove)
%SWEEPSETFILTER/REMOVESWEEPNOTE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ $Date: 2004/02/09 08:12:07 $

% Logical matrix of 1's of length obj.sweepNotes
lNotes = true(1, length(obj.sweepNotes));
% Set the notes to remove to be 0
lNotes(notesToRemove) = false;
% Update the sweep notes field
obj.sweepNotes = obj.sweepNotes(lNotes);
% Tell everyone that the sweep notes have changed
queueEvent(obj, 'ssfSweepNotesChanged');
