function g= lmgroup(L);
% LOCALMOD/LMGROUP localmod grouping for setup

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:56 $

g= class(L.userdefined);
if strcmp(g,'xregusermod') & isGrowth(L)
	g= 'Growth';
end