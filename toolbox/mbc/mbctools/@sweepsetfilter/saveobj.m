function S= saveobj(S);
% SWEEPSETFILTER/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:12:12 $

if isa(S.variableSweepset,'sweepset')
	S.variableSweepset = saveobj(S.variableSweepset);
end

S = setCacheState(S, false);
