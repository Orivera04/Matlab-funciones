function n= name(m);
% xreg3xspline/NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:32 $

if nfactors(m)>1
	n= ['Spline x ',name(m.cubic)];
else
	n= 'Spline';
end
