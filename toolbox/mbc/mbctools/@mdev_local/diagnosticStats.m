function [data,factors,standardPlotStr,olIndex]= diagnosticStats(mdev,SNo,X,Y,DataOK,m);
% MDEV_LOCAL/DIAGNOSTICSTATS determine diagnostic stats for local node
%
% [data,factors,standardPlotStr,olIndex]= diagnosticStats(mdev,SNo,X,Y,DataOK);
% Inputs
%   mdev        modeldev object
%   SNo         Test Number (default=1st fitted sweeps)
%   X,Y,DataOK  Optional output from FitData(mdev,SNo);
% Outputs
%   data        diagnostic statistics in column-based matrix
%   factors     names of signals in data matrix
%   standardPlotStr  headings for special (lower) plots in model browser
%   olIndex     index to potential outliers (note this index does not
%               include removed data)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:04:28 $

if nargin<2
   f= find(mdev.FitOK);
   SNo= f(1);
end
if nargin <6
    m= LocalModel(mdev,SNo);
end
if nargin<5 || isempty(DataOK)
   % get data 
   [X,Y,DataOK]= FitData(mdev,SNo);
end
Y(~DataOK)= NaN;

%% get new diag stats for model
[data,factors,standardPlotStr]= diagnosticStats(m,X,Y);

% add monitor variables to scatter plot
TP= mdevtestplan(mdev);
mvars= getMonitor(TP);
if ~isempty(mvars) & ~isempty(mvars.values) 
   MDATA= getdata(TP,'ALLDATA');
   MDATA= MDATA(:,mvars.values,SNo);
   MDATA= MDATA(DataOK,:);
   data = [data double(MDATA)];
   factors= [factors(:); mvars.values(:)]';
end

% outlier algorithm now uses monitor plot variables
olIndex= outliers(m,data,factors);
