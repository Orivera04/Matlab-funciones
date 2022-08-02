function [newSS, newRecordIndex] = addRecord(SS, sweepIndex)
%ADDRECORD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



newSS = SS;
if islogical(sweepIndex)
	sweepIndex = find(sweepIndex);
else
	sweepIndex = unique(sweepIndex);
end

recsToAdd = length(sweepIndex);

oldSizes = tsizes(SS);
% Find the indicies of the last point in each sweep
sweepEnd   = tstart(SS) + oldSizes - 1;
% Create the record to Add
recordsToAdd = NaN*ones(recsToAdd, SS.nvar);
% Generate the new data and baddata
newSS.nrec = SS.nrec + recsToAdd;
newSS.data = zeros(newSS.nrec, newSS.nvar);
newSS.baddata = sparse(zeros(newSS.nrec, newSS.nvar));
newSS.guid = guidarray(newSS.nrec);

lOldData = true(1, newSS.nrec);
newRecordIndex = sweepEnd(sweepIndex) + [1:recsToAdd];
lOldData(newRecordIndex) = 0;

% Copy the new data
newSS.data(~lOldData, :)    = recordsToAdd;
newSS.baddata(~lOldData, :) = recordsToAdd;
newSS.guid(~lOldData)       = guidarray(recsToAdd);

% Copy the old data
newSS.data(lOldData, :)     = SS.data;
newSS.baddata(lOldData, :)  = SS.baddata;
newSS.guid(lOldData)        = SS.guid;

% Update the underlieing xregdataset
newSizes = oldSizes;
newSizes(sweepIndex) = newSizes(sweepIndex) + 1;
newSS.xregdataset = xregdataset(testnum(SS), type(SS), newSizes);