function mdev= mapptr(mdev,RefMap);
% MODELDEV/MAPPTR 
% 
% mdev= mapptr(mdev,RefMap);
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:42 $

% datum links
mdev.RFData= mapptr(mdev.RFData,RefMap);

mdev.modeldev= mapptr(mdev.modeldev,RefMap);