function mdev= mle_ApplyOutliers(mdev,rfind,ind);
%MLE_APPLYOUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:04:46 $



mdev= mle_outliers(mdev,rfind,ind);

st= children(mdev,'status');

% switch status to 1 to indicate mle needs update (note the no climb option)

if status(mdev)==2
	mdev= status(mdev,1);
end

% update the diagniostic stats
L= model(mdev);
TSmle= mdev.MLE.Model;

[Xg,Yrf,Sigma]= mledata(mdev,0,mdev.MLE.Modes(2));
Diags= diagnosticStats(TSmle,Xg,Yrf,Sigma);

ch= children(mdev,RFstart(L)+mdev.ResponseFeatures(1,:));
for i=1:length(ch)
	DS= struct('Observed',Diags.Observed(:,i),...
		'Yhat',Diags.Yhat(:,i),...
		'Residuals',Diags.Residuals(:,i),...
		'SResiduals',Diags.SResiduals(:,i));
	ch(i).UpdateDiagnostics(DS);
end


% update dynamic opy
xregpointer(mdev);
