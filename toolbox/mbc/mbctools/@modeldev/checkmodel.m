function OK= checkmodel(mdev);
% MODELDEV/CHECKMODEL check the integrety of the model objects at load time 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:02 $

OK=1;
if isa(mdev.Model,'xregmodel')
   OK= checkmodel(mdev.Model);
	yi= yinfo(mdev.Model);
	if strcmp(yi.Name,'y');
		% update all the model info
		mdev= modelinfo(mdev);
	end
	
else
   error([fullname(mdev),'''s model is corrupt '])
end