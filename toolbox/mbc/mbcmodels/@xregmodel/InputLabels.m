function str= InputLabels(m)
% XREGMODEL/INPUTLABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:10 $

xi=m.Xinfo;
str= cell(nfactors(m),1);
for j=1:nfactors(m)
	strj= xi.Symbols{j};
	
	uct= char(xi.Units{j});
	if ~isempty(xi.Names{j}) & ~strcmp(strj, xi.Names{j}) ;
		strj = [xi.Names{j} ' (',strj,')'];
	end
	if ~isempty(uct) & ~strcmp(uct,'?')
		strj = [strj ' [' uct ']'];
	elseif isempty(uct) & isa(xi.Units{j},'junit')
		strj = [strj ' [-]'];
	end
	str{j}= strj;
end
