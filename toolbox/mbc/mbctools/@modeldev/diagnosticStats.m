function [data,factors,standardPlotStr,olIndex]= diagnosticStats(mdev)
%DIAGNOSTICSTATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.4 $  $Date: 2004/04/04 03:31:50 $

m= model(mdev);

[X,Y,DataOK]= FitData(mdev);
Y(~DataOK)= NaN;

% get new stats
[data,factors,standardPlotStr]= diagnosticStats(m,X,Y);
if mdev.ModelStage==1
	% add monitor variables to scatter plot
	TP= mdevtestplan(mdev);
	mvars= getMonitor(TP);
	if ~isempty(mvars) & ~isempty(mvars.values) 
		MDATA= getdata(TP,'ALLDATA');
		MDATA= MDATA(:,mvars.values);
		if size(X,1)==size(X,3)
			MDATA= MDATA(DataOK,:);
			data = [data double(MDATA)];
			factors= [factors(:); mvars.values(:)]';
		end
	end
end
% get outlier indices
olIndex= outliers(m,data,factors);
