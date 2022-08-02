function Diags= mle_diagnostics(mdev,PredMode);
% MDEV_LOCAL/MLE_DIAGNOSTICS diagnostic plots for MLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:49 $

TSmle= mdev.MLE.Model;

[Xg,Yrf,Sigma]= mledata(mdev,0,PredMode);
Diags= diagnosticStats(TSmle,Xg,Yrf,Sigma);
