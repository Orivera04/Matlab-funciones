function [data,factors,specialPlots,olIndex]= diagnosticStats(m,Xs,Ys)
% NNMODEL/diagnosticStats, stats and factors for the diagnostic plots
% 
% [data,factors, specialPlots]= diagnosticStats(m)
%
% This is an overloaded function to return
% stats and factors for the diagnostic plots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:56:17 $

% This gets the standard statistics
%data= stats(m,'diagnostics',X,Y);

[Xc,Y,DataOk]= checkdata(m,Xs,Ys);
% Get the global variables.
p= get(MBrowser,'CurrentNode');
if nargin<3
   [X,Y]= getdata(p.info);
   [Xc,Y,DataOk]= checkdata(m,X,Y);
end	
obs= [1:length(Xc)]';
yhat = eval(m,Xc);
y= double(Y);
r   = y - yhat;
z=   r/std(r(isfinite(r)));
Xm= invcode(m,Xc);
data=[obs,...
      r,...
      yhat,...
      y,...
      z,...
      Xm];

% This returns the names of the statistics
% sname= get(Xs,'name');
% snameY= p.name;
sname = InputLabels(m);
snameY= ResponseLabel(m);
% make it a row
[r,c]= size(sname);
if r>c
   sname= sname';
end
factors ={'Obs. No.',...
      'Residuals',...
      ['Predicted ',snameY],...
      snameY,...
      'Normalized residuals'};
factors=[factors,sname];

specialPlots= '';
olIndex= outliers(m,data,factors);
