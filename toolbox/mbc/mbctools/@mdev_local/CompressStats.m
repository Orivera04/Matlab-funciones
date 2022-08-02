function mdev= CompressStats(mdev);
% MDEV_LOCAL/COMPRESSSTATS compresses twostage stats after validation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:03:59 $

TSIndex= BestModel(mdev.modeldev);

Tstats= mdev.TSstatistics;
Tstats.Summary= Tstats.Summary(TSIndex,:);
Tstats.RespFeat= Tstats.RespFeat(:,TSIndex);
Tstats.LogL = Tstats.LogL(:,TSIndex);
Tstats.RMSE = Tstats.RMSE(:,TSIndex);

mdev.TSstatistics= Tstats;
mdev.TwoStage= mdev.TwoStage(TSIndex);
mdev.ResponseFeatures= mdev.ResponseFeatures(TSIndex,:);
mdev.modeldev= BestModel(mdev.modeldev,1);

pointer(mdev);