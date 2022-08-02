function freeptr(mdev)
% MDEV_LOCAL/FREEPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:32 $

if mdev.RFData~=0
	freeptr(mdev.RFData);
end
