function [data,factors,specialPlots,olIndex]= diagnosticStats(m,X,Y)
%DIAGNOSTICSTATS   Stats for diagnostic plots
%   [data,factors,specialPlots]= DIAGNOSTICSTATS(m)
%   This is an overloaded function to return stats and factors for the 
%   diagnostic plots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:48:42 $ 



% Get the global variables.
if nargin<3
   p= get(MBrowser,'CurrentNode');
   [X,Y]= getdata(p.info);
end	
[Xm,Ym,DataOk]= checkdata(m,X,Y);
Xm= invcode(m,Xm);
yhat= EvalModel(m,Xm);
% Plot indexes.
obs=[1:length(Ym)]';
data= [obs,...
      yhat,...
      Ym-yhat,...
      Ym,...
      Xm];
% This returns the names of the statistics
% sname= get(X,'name');
% snameY= p.name;
sname = InputLabels(m);
snameY= ResponseLabel(m);
% make it a row
[r,c]= size(sname);
if r>c
   sname= sname';
end

factors={'Obs. number',...
      ['Predicted ',snameY],...
      'Residuals',...
      snameY};

factors= [factors,sname];

% This is a list of special plots. This can be empty
specialPlots= {};

% outlier index
olIndex= outliers(m,data,factors);

% EOF
