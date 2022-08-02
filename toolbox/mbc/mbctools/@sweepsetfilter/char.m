function B = char(A);
% SWEEPSETFILTER/CHAR char converter for sweepsetfilter object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:38 $

strName = [' Name        : ' A.name];

if isempty(A.filters)
	strFilter = ' Filters     : ';
else
	[filters{1:length(A.filters)}] = deal(A.filters.filterExp);
	space = ' ';
	title = strvcat(' Filters     : ', space(ones(length(A.filters)-1,1),:));
	strFilter = [title strvcat(filters)];
end

% If there aren't any filters then ensure the first contains an empty matrix
if isempty(A.variables)
	strVariable = ' Variables   : ';
else
	[varName{1:length(A.variables)}] = deal(A.variables.varName);
	names = strvcat([' Variables   : ' varName{1}], char(varName(2:end)));
	names = strjust(names, 'right');
	equals = repmat(' = ', size(names, 1), 1);
	[varExp{1:length(A.variables)}] = deal(A.variables.varExp);
	strVariable = [names equals strvcat(varExp)];
end

B = strvcat(strName, char(sweepset(A)), strFilter, strVariable);

