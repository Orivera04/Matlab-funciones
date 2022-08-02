function mdev= refit(mdev)
% MODELDEV/REFIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:49 $

mdev.Model= reset(mdev.Model);
[ok, mdev]= fitmodel(mdev);
