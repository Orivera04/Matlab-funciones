function mdev= undovalidate(mdev)
% MDEV_LOCAL/UNDOVALIDATE undo validation effects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:05:17 $

oldMDEV= history(mdev,'get');
if ~isempty(oldMDEV)
   if isfield(oldMDEV.MLE,'Validate') 
      mdev.MLE.Validate=oldMDEV.MLE.Validate;
   end
   if isfield(oldMDEV.MLE,'BestModel') 
      mdev.MLE.BestModel=oldMDEV.MLE.BestModel;
   end
   if isfield(oldMDEV.MLE,'Model') 
      mdev.MLE.Model=oldMDEV.MLE.Model;
   end
   
   if ~isempty(mdev.ResponseFeatures)
      mdev.TwoStage= oldMDEV.TwoStage;
      mdev.ResponseFeatures=oldMDEV.ResponseFeatures;
      mdev.TwoStage        =oldMDEV.TwoStage;
      mdev.TSstatistics    =oldMDEV.TSstatistics;
      
      bm=BMIndex(oldMDEV);
      mdev.modeldev= BestModel(mdev.modeldev,bm);
   end
   %   mdev= statistics(mdev,statistics(oldMDEV));
   mdev=history(mdev,'clear');
   pointer(mdev);
end
