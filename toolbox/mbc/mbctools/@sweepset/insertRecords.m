function [newSS, newRecordIndex] = insertRecords(SS, currentRecordIndex, newData)
%INSERTRECORDS add records into pre existing sweeps 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


% Copy the sweepset
newSS = SS;
% How many records are being added
recsToAdd = size(newData, 1);

% Make sure we have a sensible set of inputs
if ~isequal(length(currentRecordIndex), recsToAdd)    
    error('mbc:sweepset:InvalidArgument', 'Invalid Index into new data');
elseif min(currentRecordIndex) < 1
    error('mbc:sweepset:InvalidIndex', 'Indices must be positive integers');    
elseif max(currentRecordIndex) > SS.nrec
    error('mbc:sweepset:InvalidIndex', 'New record indics must not exceed the size of the data');    
elseif ~isequal(SS.nvar, size(newData, 2))
    error('mbc:sweepset:InvalidArgument', 'New records must have the same number of variables as the sweepset');
end
% Make sure that currentRecordIndex is sorted correctly
[currentRecordIndex, index] = sort(currentRecordIndex);
newData = newData(index, :);
% Need to convert currentRecordIndex into a index in the new sweepset -
% i.e need to add one to each currentRecordIndex where there is a new
% record added before it. 
newRecordIndex = currentRecordIndex + cumsum(sign(currentRecordIndex));

% Generate the new data and baddata in correct size
newSS.nrec = SS.nrec + recsToAdd;
newSS.data = zeros(newSS.nrec, newSS.nvar);
newSS.baddata = sparse(zeros(newSS.nrec, newSS.nvar));
% Create a guid array large enought to reference into
newSS.guid = guidarray(newSS.nrec);

% Create the logical reference into the data matrix
lOldData = true(1, newSS.nrec);
lOldData(newRecordIndex) = 0;
lNewData = ~lOldData;
% Copy the new data
newSS.data(lNewData, :)     = newData;
% Copy the old data
newSS.data(lOldData, :)     = SS.data;
newSS.baddata(lOldData, :)  = SS.baddata;
newSS.guid(lOldData)        = SS.guid;

% Update the underlieing xregdataset - need to work out where data was
% added
newSizes = tsizes(SS);
oldStartIndex = cumsum([1 newSizes]);
for i = 1:length(newSizes)
    numFound = sum(currentRecordIndex >= oldStartIndex(i) & currentRecordIndex < oldStartIndex(i+1));
    newSizes(i) = newSizes(i) + numFound;
end
newSS.xregdataset = xregdataset(testnum(SS), type(SS), newSizes);