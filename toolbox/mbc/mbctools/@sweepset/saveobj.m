function S= saveobj(S);
% SWEEPSET/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:28 $

for i=1:length(S.var);
	if isa(S.var(i).units,'junit')
		S.var(i).units= saveobj(S.var(i).units);
	end
end
