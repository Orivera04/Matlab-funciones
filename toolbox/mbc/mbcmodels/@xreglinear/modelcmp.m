function c= modelcmp(m1,m2)
% XREGLINEAR/MODELCMP compare models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:47 $

c= strcmp(class(m1),class(m2)) & nfactors(m1)==nfactors(m2) & size(m1,1)==size(m2,1);

if c
	o1= get(m1,'order');
	o2= get(m2,'order');
	c= c & getstatus(m1)==getstatus(m2) & all(o1==o2);
end