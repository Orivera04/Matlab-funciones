function [data,factors,standardPlotStr,olIndex]= diagnosticStats(mdev);
%DIAGNOSTICSTATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.8.4.3 $  $Date: 2004/02/09 08:05:37 $




m= model(mdev);

[X,Y,DataOK]= FitData(mdev);
Y(~DataOK)= NaN;
DS= mdev.DiagStats;
ns= size(DS.Yhat,1);
if ns~=sum(DataOK)
   % remake diag stats
   p= Parent(mdev);
   p.makemlerf;
   mdev= info(mdev);
   [X,Y,DataOK]= FitData(mdev);
   Y(~DataOK)= NaN;
   DS= mdev.DiagStats;
   ns= size(DS.Yhat,1);
end

sname = InputLabels(m);
snameY= ResponseLabel(m);

data= [DS.Yhat DS.SResiduals DS.Residuals [1:ns]' DS.Observed double(X(DataOK,:))];

factors=[{['Predicted ',snameY]
            'Studentized residuals'
            'Residuals'
            'Obs. number'
            snameY}
		sname];

standardPlotStr ={'Predicted/Observed','Normal plot'};

olIndex= [];
