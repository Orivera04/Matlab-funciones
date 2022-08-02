function mdev= loadobj(mdev)
% MDEV_LOCAL/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:37 $

if isa(mdev,'struct')
   mdev= mdev_local(mdev);
end
if isfield(mdev.MLE,'Model') & length(mdev.TwoStage)==2
	mdev.MLE.Model= mdev.TwoStage{2};
end
