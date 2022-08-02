function M = loadobj(Mold)
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:55 $

if isstruct(Mold)
	M = cgfuncmodel;
	if isfield(Mold,'func')
		M.func = Mold.func;
	end
	if isfield(Mold,'funcv')
		M.funcv = Mold.funcv;
	end
	if isfield(Mold,'compiled')
		M.compiled = Mold.compiled;
	end
else
	M = Mold;
end