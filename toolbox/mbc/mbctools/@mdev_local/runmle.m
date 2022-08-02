function mdev= runmle(mdev,mleOptions);
%MDEV_LOCAL/RUNMLE run mle estimation algorithm for two-stage model
%
% mdev= runmle(mdev,mleOptions);
% create mle model
%   mleOptions= [InitVal PredMode CovAlg TolFun];
%      InitVal   0= univariate , 1= mle
%      PredMode  0= delete any test with outliers , 1 replace missing data
%                  wih predicted value
%      CovAlg    1= Quasi-Newton , 2= Expectation-Maximization
%      TolFun    Stopping Criterion

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:05:07 $

if nargin<2
    mleOptions = mle_modes(mdev);
else
    mdev.MLE.Modes = mleOptions;
    xregpointer(mdev);
end
if isempty(mleOptions)
    % defaults 
    mleOptions= [0 1 2 1e-3];
    mdev.MLE.Modes = mleOptions;
end
if mleOptions(1) && length(mdev.TwoStage)==2
    InitVal= 'mle';
else
    mdev.MLE.Modes(1) = 0;
    InitVal= 'univariate';
end    
PredMode= mleOptions(2);
switch mleOptions(3)
    case 1
        CovAlg= 'mlelin';
    case 2
        CovAlg= 'mle_ExpMaxim';
end
TolFun= mleOptions(4);
% run mle
mdev= mle(mdev,InitVal,CovAlg,TolFun,{},PredMode);