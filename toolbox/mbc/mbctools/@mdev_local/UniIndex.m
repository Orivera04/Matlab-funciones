function [bmIndex]= UniIndex(mdev);
% MDEV_LOCAL/UNIINDEX best univariate twostage model for mdev_local node

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:16 $

if isempty(mdev.TwoStage)
   TS= [];
   bmIndex=[];
else
   if mle_isrun(mdev)
      % this condition occurs if mle has been run
      bmIndex=1;
   else
      bmIndex= BestModel(mdev.modeldev);
   end
	% initialise the univariate store
   mdev= InitStore(mdev,bmIndex);
end