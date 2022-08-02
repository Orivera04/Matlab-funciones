function p= getptrs(mdev);
% MDEV_LOCAL/GETPTRS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:33 $

p=[];
if mdev.RFData~=0
	p= mdev.RFData;
end
p= [p getptrs(mdev.modeldev)];