function mdev=  clearmodels(mdev);
% MDEV_LOCAL/CLEARMODELS clear local model results 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:22 $


mdev.AllModels= [];
mdev.GLSWeights= {};
mdev.FitOK= [];

pointer(mdev);
