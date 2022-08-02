function [out, OK, msg] = align(SS1, SS2, vars)
%ALIGN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:00 $

OK = 0;
out = sweepset;
msg = '';

% Do ss1 and ss2 contain variables vars?
if isempty(find(SS1, vars)) | isempty(find(SS2, vars))
	msg = 'Requested variables not found in both sweepsets';
	return
end

% First, is alignment possible? i.e. does vars uniquely identify a record
S = substruct('()',{':' vars});
alignSS1 = subsref(SS1, S);
alignSS2 = subsref(SS2, S);
[sortSS1, index1] = sortrows(alignSS1.data);
[sortSS2, index2] = sortrows(alignSS2.data);

% Note: sortSS1 = SS1(index1) but we want SS1 = sortSS1(invIndex1)
[temp, invIndex1] = sort(index1);

% NaN's are put at end of sort. So any NaN's will be in last row. NaN fails at intersect
if any(isnan(sortSS1(end,:))) | any(isnan(sortSS2(end,:)))
	msg = 'Alignment is not possible on datasets that include NaN''s or bad data';
	return
end

% Is SS1 uniquely identified by the suggested variables
if size(sortSS1, 1) ~= size(unique(sortSS1, 'rows'), 1)
	msg = 'Record alignment cannot be unique with selected variables';
	return
end

% Find the intersection of these two sorted datasets.
% NOTE: C = sortSS1(ind1) & C = sortSS2(ind2)
[C, ind1, ind2] = intersect(sortSS1, sortSS2, 'rows');

% Did we find a matching partner for everyone in sortSS1?
if ~isequal(C, sortSS1)
	msg = ['Only ' num2str(size(C, 1)) ' matching records found in the sweepset being aligned'];
	return
end

% Is SS2 also unique in the selected variables. 
% i.e. are there duplicates in SS2 which match SS1
dupSS2 = sum(diff(sortSS2, 1, 1), 2) == 0;
if any(dupSS2)
	C = intersect(sortSS2(dupSS2), sortSS1, 'rows');
	if ~isempty(C)
		msg = 'Sweepset to be aligned cannot be uniquely identified with selected variables';
		return
	end
end
% Now we know there is a one-to-one mapping between the variables vars in SS1 and SS2
% So map SS2 onto SS1 in the correct order.
index = index2(ind2(invIndex1));
[varsToAppend indexVarsToAppend] = setdiff(get(SS2, 'name'), get(SS1, 'name'));

% Now append all variables from SS2 to SS1
S = substruct('()', {index, indexVarsToAppend, ':'});
out = [SS1 subsref(SS2, S)];
OK = 1;