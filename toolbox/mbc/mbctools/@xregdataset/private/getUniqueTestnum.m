function uniqueNum = getUniqueTestnum(num)
% GETUNIQUETESTNUM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:19:02 $




% Get rid of any infinities and NaNs
num(~isfinite(num)) = 0;

% By default we assume the numbers are unique
uniqueNum = num;
if numel(num) == 1
	return
end

[sNum, i] = sort(num);

d = diff(sNum);
% Increment the find by 1 because diff reduces the length by 1
j = find(d == 0) + 1;
% If no numbers are the same then return with uniqueNum = num
if isempty(j)
	return
end
% Need to deal with non-unique numbers so get the last integer in the sort
lastInt = floor(sNum(end));
% Get new index numbers
newIndex = (1:length(j)) + lastInt;
% Reassign index numbers in ascending order
i = sort(i(j));
uniqueNum(i) = newIndex;
