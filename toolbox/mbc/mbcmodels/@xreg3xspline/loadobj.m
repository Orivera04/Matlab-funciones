function m=loadobj(m);
% xreg3xspline/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:31 $

if isa(m,'struct');
	m = xreg3xspline(m);
end
