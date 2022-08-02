function out = char(p);
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:35 $

descrp = '';
if isempty(p)
	descrp = ' Empty set';
else
	factors = get(p,'factors');
	factortype = get(p,'factor_type');
	for i = 1:length(factors)
		if factortype(i)==1 %input
			descrp = [descrp factors{i} ', '];
		end
	end
	nf = get(p,'numfactors');
	np = get(p,'numpoints');
	pl1 = 's'; if nf==1, pl1 = ''; end
	pl2 = 's'; if np==1, pl2 = ''; end
	descrp = [' (' descrp(1:end-2) ') ' num2str(np), ' point',pl2];
end
out = [getname(p) , ': ' , descrp ];