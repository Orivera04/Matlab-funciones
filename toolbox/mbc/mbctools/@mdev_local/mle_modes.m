function modes= mle_modes(mdev)
% MDEV_LOCAL/MLE_MODES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:51 $

if isfield(mdev.MLE,'Modes')
   modes= mdev.MLE.Modes;
else
   modes=[];
end