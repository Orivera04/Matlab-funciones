function mdev= RFData(mdev,prf)
% MDEV_LOCAL/RFDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:06 $

if nargin==1
	mdev= mdev.RFData;
else
	mdev.RFData= prf;
	pointer(mdev);
end