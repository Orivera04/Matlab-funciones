function [TS,bmIndex]= univariate(mdev);
% MDEV_LOCAL/UNIVARIATE best univariate twostage model for mdev_local node

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:18 $

if isempty(mdev.TwoStage)
   TS= [];
   bmIndex=[];
else
   if isfield(mdev.TSstatistics,'RFpress') & size(mdev.TSstatistics.RFpress,2)==1
      % this condition occurs if mle has been run
      bmIndex=1;
   else
      bmIndex= BestModel(mdev.modeldev);
   end
   mdev= InitStore(mdev,bmIndex);
   TS= mdev.TwoStage{bmIndex};
   [Bnd,g,Tgt]= getcode(TS);
   if ((Tgt(1,1)==0 | Tgt(1,1)==-1) & Tgt(1,2)==1);
      
      [TS,mdev]= tsinfo(mdev,TS);

      % update mdev
      mdev.TwoStage{bmIndex}= TS;
      pointer(mdev);
   end
end