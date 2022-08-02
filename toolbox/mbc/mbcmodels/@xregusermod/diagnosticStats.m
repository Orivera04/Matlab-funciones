function [data,factors,specialPlots,olIndex]= diagnosticStats(m,X,Y)
% xregusermod/diagnosticStats
% 
% [data,factors, specialPlots]= diagnosticStats(m)
%
% This is an overloaded function to return
% stats and factors for the diagnostic plots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:01:01 $


% Get the global variables.
if nargin==1
    p= get(MBrowser,'currentNode');
    [X,Y]= getdata(p.info);
end
[Xm,Ym,DataOk]= checkdata(m,X,Y);

yhat  = eval(m,Xm);



res= Ym-yhat;

Xm= invcode(m,Xm);
% Plot indexes.
obs=[1:length(Ym)]';
data= [yhat,...
      res,...
      obs,...  
      Ym,...
      Xm];
% This returns the names of the statistics
sname = InputLabels(m);
snameY= ResponseLabel(m);
% make it a row
[r,c]= size(sname);
if r>c
   sname= sname';
end

factors={['Predicted ',snameY],...
      'Residuals',...
      'Obs. number',...
      snameY};

factors= [factors,sname];

% This is a list of special plots. This can be empty
specialPlots= {'Predicted/Observed'};

% outlier index
olIndex= outliers(m,data,factors);
