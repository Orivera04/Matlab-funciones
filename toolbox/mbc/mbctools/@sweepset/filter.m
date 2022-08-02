function B = filter(A, removeRecordIndex, keepVariableIndex, removeSweepIndex)
% SWEEPSET/FILTER Function to filter out records and sweeps from a sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% NOTE - old return from filter was
% [B, keepRecord, keepVariable] = filter(A, removeRecordIndex, keepVariableIndex, removeSweepIndex);
% But keepRecord and keepVariable no longer needed in sweepsetfilter and so
% commented out here for a slight speed increase


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:06:14 $

% Copy A to B
B = A;

%%% TO DO - Need to deal with multilevel sweep index here
if iscell(removeSweepIndex) & ~isempty(removeSweepIndex)
	removeSweepIndex = removeSweepIndex{1};
end

% First need to combine record and sweep indicies for removal
nrec = A.nrec;
nvar = A.nvar;

% Note l for logical array. These are place holders to see if we need to
% OR removeSweep and removeRecord together
lKeepSweep    = false(0);
lKeepRecord   = false(0);
lKeep         = true(1, nrec);

% Do we have any sweeps to remove, and if so get the records associated with those sweeps
if ~isempty(removeSweepIndex)
	% Allocate memory for logical array
	lKeepSweep = true(1, nrec);
	% Get record indicies of sweeps to remove
	removeSweepRecordIndex = RecPos(A, removeSweepIndex);
	% Remove the records from the logical array
	lKeepSweep(removeSweepRecordIndex) = 0;
	% Speed issue : if no records are filtered (i.e. removeRecordIndex == []) then
	% we have already got lKeep
	lKeep = lKeepSweep;
end

% Do we have any records to remove
if islogical(removeRecordIndex) & length(removeRecordIndex) == nrec
	% This case deal with a logical removeRecordIndex input that directly indexes
	% the sweepset data
	lKeepRecord = ~removeRecordIndex;
	% Speed issue : see above
	lKeep = lKeepRecord;
elseif ~isempty(removeRecordIndex)
	% Allocate Memory
	lKeepRecord = true(1, nrec);
	lKeepRecord(removeRecordIndex) = 0;
	% Speed Issue : see above
	lKeep = lKeepRecord;
end

% Do we need to filter out any of the variables
if isempty(keepVariableIndex)
	lKeepVariable = true(1, nvar);
else
	% Have we been given a cell array of names? Convert to indicies
	if iscell(keepVariableIndex)
		keepVariableIndex = find(A, keepVariableIndex);
	end
	lKeepVariable = false(1, nvar);
	lKeepVariable(keepVariableIndex) = 1;
end

% Do we need to combine the logical arrays ?
if all(lKeep) & all(lKeepVariable)
	% Both removeSweepIndex and removeRecordIndex were empty so return with the same sweepset
% 	keepRecord = 1:length(lKeep);
% 	keepVariable = 1:length(lKeepVariable);
	return
elseif ~isempty(lKeepSweep) & ~isempty(lKeepRecord)
	% Both removeSweepIndex and removeRecordIndex contained indicies soe we need to AND the 
	% records to keep
	lKeep = lKeepSweep & lKeepRecord;
end

% Generate return arguments
% keepRecord = find(lKeep);
% keepVariable = find(lKeepVariable);

% Filter the data and the bad data fields
B.data = A.data(lKeep, lKeepVariable);
B.baddata = A.baddata(lKeep, lKeepVariable);
B.guid = A.guid(lKeep);
B.nrec = sum(lKeep);
B.var = A.var(lKeepVariable);
B.nvar = sum(lKeepVariable);

% Update sweep sizes and selected sweeps
[B,ind] = sweeppos(B,lKeep);
