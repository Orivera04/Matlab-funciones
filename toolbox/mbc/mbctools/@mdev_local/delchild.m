function mdev=delchild(mdev,chindex);
% MDEV_LOCAL/DELCHILD handles mdev_local part of delete response feature node from tree
%
% called from tree/delete

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:04:26 $

L= model(mdev);

D= mdev.RFData.info;
D= D(:,1:size(D,2)~=chindex);
mdev.RFData.info= D;

% account for possible non RF datum model
ind=  chindex-RFstart(L);
if ind>0 & ind<=size(get(L,'Values'),1)
   
   % delete rf from localmod
   L= DelFeat(L,ind);
   mdev=model(mdev,L);
   
   % update rf covariance
   mdev.MLE.Sigma(ind,:,:)=[];
   mdev.MLE.Sigma(:,ind,:)=[];
   
   % could be deleting an rf in bestmodel
   if ~isempty(mdev.ResponseFeatures)
      if any(mdev.ResponseFeatures(:)==ind);
         mdev= BestModel(mdev,0);
      end
      % mdev.ResponseFeatures uses indices rather than pointers
      rf= mdev.ResponseFeatures;
      mdev.ResponseFeatures(rf>ind)= mdev.ResponseFeatures(rf>ind)-1;
   end
	
	
   p=pointer(mdev);
end
