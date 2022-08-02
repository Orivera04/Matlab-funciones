function [OK, msg, out] = xregReadConcerto(filename, out)
% XREGREADCONCERTO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 08:21:03 $




% This function assumes that the concerto file was saved with a single layout
OK = 0;
msg = '';
% Read the first line to find out how many variables are involved
firstLine = textread(filename, '%s', 1, 'delimiter','\n\r');
% How many tabs since each variable is delimited by a tab
numVars = sum(firstLine{1} == char(9));
% Now read in the whole file delimited on tabs
data = textread(filename, '%s', 'whitespace', '\b\n\r ', 'delimiter','\t');
% Have we got the number of variables correct
numRows = length(data)/numVars;
if floor(numRows) ~= numRows
	msg = 'Unable to reconcile shape of Concerto text file';
	return
end
data = reshape(data, [numVars numRows])';
% Extract variable names and units from data
out.varNames = data(1,:);
out.varUnits = data(2,:);
% Remove top variable and units line
data = data(3:end,:);
% Convert all the data to real
realData = xregcellstr2real(data);
% Remove all rows that are entirely NaN
indGoodData = find(sum(~isnan(realData), 2) ~= 0);
% Keep the good data
realData = realData(indGoodData, :);
% Need to find single entry data for each sweep and replicate downwards
indRowMissing = find(isnan(realData(:,1)));
if length(indRowMissing) > 0 & length(indRowMissing) < size(realData, 1)
	% How many columns are affected?
	indLastCol = find(diff(isnan(realData(indRowMissing(1), :))));
	if isempty(indLastCol)
		indLastCol = size(realData, 2);
	elseif length(indLastCol) > 1
		indLastCol = indLastCol(1);
	end
	% Need to include one extra row for bounds checking
	indRowExist = setdiff(1:size(realData, 1)+1, indRowMissing);
	for i = 1:length(indRowExist)-1
		validRows = indRowMissing > indRowExist(i) & indRowMissing < indRowExist(i+1);
		numRows = sum(validRows);
		realData(indRowMissing(validRows), 1:indLastCol) =...
			repmat(realData(indRowExist(i), 1:indLastCol), numRows, 1);
	end
end
out.data = realData;
OK = 1;
