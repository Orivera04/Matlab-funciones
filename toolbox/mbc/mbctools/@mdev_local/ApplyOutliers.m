function mdev= ApplyOutliers(mdev,SweepPos,ind)
%MDEV_LOCAL/APPLYOUTLIERS changes outliers and refits model
%
%  mdev= ApplyOutliers(mdev,SweepPos,ind)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.4.3 $  $Date: 2004/02/09 08:03:53 $

% update outliers
p= outliers(mdev,ind);
mdev= p.info;   

Lold= model(mdev);

% change to 0 iterations so covariance model is not updated
OldFitAlg= get(Lold,'fitalg');
set(Lold,'fitalg','ols')
mdev= model(mdev,Lold);

mdev.AllModels(:,SweepPos)=NaN;
Y= getdata(mdev,'Y');
% refit model 
[OK,mdev]= fitmodel(mdev,SweepPos);
% model might have been changed by FitModel
L= model(mdev);
set(L,'fitalg',OldFitAlg)
mdev= model(mdev,L);

pointer(mdev);
