function [Xg,Yrf,Sigma]= mledata(mdev,ModelNo,PredMode);
% MDEV_LOCAL/MLEDATA get data for MLE
%
% [TS,Xg,Yrf,Sigma]= mledata(mdev,ModelNo);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.4 $  $Date: 2004/02/09 08:04:56 $



if ModelNo>0
   % selected model
   selrf= mdev.ResponseFeatures(ModelNo,:);
   TS= mdev.TwoStage{ModelNo};
else
   % use MLE model
   selrf= mdev.ResponseFeatures(1,:);
   TS= mdev.MLE.Model;
end


% local regresion covariance information
%  Ci in D&G , Sigmai in Mark C notation
Sigma= mdev.MLE.Sigma(selrf,selrf,:);
sse=  mdev.MLE.SSE;
df= mdev.MLE.df;
DFT= sum(df(mdev.FitOK));
if DFT
   s2= sum(sse(mdev.FitOK))/DFT;
else
   s2= 0;
end
% use real covariance rather than inv(X'*X)
Sigma= s2*Sigma;

L= model(mdev);

selrf= selrf + RFstart(L); % add datum node if necessary
% get response feature data 
Yrf= children(mdev,'getdata','Y',0);
rfout= children(mdev,'rfoutliers');
for i=1:length(Yrf)
   Yrf{i}= double(Yrf{i});
   Yrf{i}(rfout{i})= NaN;
end
Yrf= [Yrf{:}];

Yrf= Yrf(:,selrf);
if ~isfield(mdev.MLE,'Outliers');
   % set up MLE Outliers 
   mdev.MLE.Outliers= false(size(Yrf));
   pointer(mdev);
end

% assign any outliers to NaN (cleaned by TWOSTAGE/CHECKDATA)
Yrf( mdev.MLE.Outliers~=0 )= NaN;
if nargin>2 & ~PredMode
   % PREDMODE will replace NaN's with predicted value as long as 
   % there are some finite Yrf for the sweep
   bd= any(~isfinite(Yrf),2);
   Yrf(bd,:)= NaN;
end


% global variables
X= getdata(mdev,'FIT');
Xg= double(X{end});

