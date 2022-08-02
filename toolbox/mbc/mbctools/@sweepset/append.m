function [out, OK, msg] = append(SS1, SS2)
%APPEND

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



OK = 0;
out = sweepset;
msg = '';

% Find common names
nameSS1 = get(SS1, 'name');
nameSS2 = get(SS2, 'name');
[common, com1, com2] = intersect(nameSS1, nameSS2);

if isempty(common)
	msg = 'No common variables found in appended sweepset';
	return
end

% Create the append data matrix, full of NaN to account for missing data
dataToAppend = zeros(SS2.nrec, SS1.nvar);
baddataToAppend = sparse(dataToAppend);
dataToAppend(:) = NaN;

% Now get the new data
dataToAppend(:, com1) = SS2.data(:, com2);
baddataToAppend(:, com1) = SS2.baddata(:, com2);

SS1.nrec        = SS1.nrec + SS2.nrec;
SS1.data        = [SS1.data; dataToAppend];
SS1.baddata     = [SS1.baddata; baddataToAppend];
SS1.guid        = [SS1.guid; SS2.guid];
SS1.xregdataset = [SS1.xregdataset; SS2.xregdataset];

OK = 1;
out = SS1;
