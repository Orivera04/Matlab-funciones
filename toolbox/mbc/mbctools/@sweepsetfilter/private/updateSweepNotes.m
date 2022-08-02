function [obj, ss] = updateSweepNotes(obj, ss, index)
%UPDATESWEEPNOTES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $   $Date: 2004/04/04 03:32:06 $

% Have we got a current copy of the sweepset
if nargin < 2 || ~isa(ss, 'sweepset')
    ss = ApplyObject(obj);
end

% Ensure that startIndex is initialised
if nargin < 3
    index = 1:length(obj.sweepNotes);
end

% Store to see if notes ares changed in the update process
INITIAL_notes = obj.sweepNotes;

% Iterate through all the sweep notes
for i = index
	obj.sweepNotes(i) = i_evaluateNote(obj.sweepNotes(i), ss);
end

% Have the notes actually changed
if ~isidentical(obj.sweepNotes, INITIAL_notes)
    queueEvent(obj, 'ssfSweepNotesChanged');
end

%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
function note = i_evaluateNote(note, ss)
try
    % Evaluate the filter criteria using sweepset/sweepeval
	note.lAppliesTo = sweepeval(ss, note.inlineExp);
    % Check that the applies to logical array isn't larger than the number
    % of sweeps
    if numel(note.lAppliesTo) ~= size(ss, 3)
        error('mbc:sweepsetfilter:InvalidExpression', 'Expression returns too large a return');
    end
    note.result = sprintf('Note successfully applied : %d tests marked', sum(note.lAppliesTo));
    note.OK = true;
catch
	note.lAppliesTo = false;
	note.result = ['Error : Ignoring note definition ''' note.noteExp ''': Invalid variable name or expression'];
    note.OK = false;
end
