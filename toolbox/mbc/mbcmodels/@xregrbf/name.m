function n= name(m);
% RBF/NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:55:01 $

kn= func2str(m.kernel);
n= ['RBF-',kn];
if strcmp(kn,'wendland')
	n= sprintf('%s%1d',n,m.cont);
end