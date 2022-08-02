function SS = convert(SS, vars, newUnits)
%CONVERT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:08 $

if ischar(vars)
	vars = {vars};
end

for i = 1:length(vars)
	if iscell(vars)
		varIndex = find(SS, vars{i});
		if isempty(varIndex)
			error(['Variable ' vars{i} ' not found in sweepset']);
		end
	else
		varIndex = vars(i);
	end
	
	oldUnit = SS.var(varIndex).units;
	newUnit = newUnits(i);
	
	if ~isa(oldUnit, 'junit')
		error(['Conversion of ' SS.var(varIndex).name ' requires a predefined junit object']);
	end
	
	if ~compatible(oldUnit, newUnit)
		error(['Conversion of ' SS.var(varIndex).name ' must occur between comaptible units']);
	end
	
	% Use sweepset/subsasgn to make sure that baddata etc are dealt with
	oldData = double(subsref(SS, substruct('()',{':' varIndex})));
	newData = convert(oldUnit, newUnit, oldData);
	SS = subsasgn(SS, substruct('()',{':' varIndex}), newData);
	SS.var(varIndex).units = newUnit;
end