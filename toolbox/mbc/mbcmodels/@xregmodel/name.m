function n = name(m)
% NAME Get model name

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:52:37 $

n = class(m);
if strncmp(n, 'xreg', 4)
	% remove xreg from name
	n = n(5:end);
end
