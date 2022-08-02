function [data,factors,specialPlots,olIndex]= diagnosticStats(L,X,Y)
%LOCALMULTI/diagnosticStats
% 
% [data,factors,specialPlots,olIndex]= diagnosticStats(m)
%
% This is an overloaded function to return
% stats and factors for the diagnostic plots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:37:36 $

m= get(L,'model');

p= get(MBrowser,'CurrentNode');
[Xall,Yall,DataOK]= FitData(p.info,':');
Yall= Yall(DataOK,:);
% [Xc,Yc,OK,bd]= checkdata(L,Xall,Yall);
[data,factors,specialPlots,olIndex]= diagnosticStats(m,Xall(DataOK,:),Yall);

ind= RecPos(Yall,find(testnum(X)==testnum(Xall)));
data= data(ind,:);

% This is a list of special plots. This can be empty
specialPlots= {'Local Response',...
      'Normal plot'};

% outlier index.
olIndex= outliers(L,data,factors);
