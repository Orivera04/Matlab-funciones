function [mdev,OK]= addoutliers(mdev,ind);
%ADDOUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:05:33 $



OK=1;

if ~isempty(ind) 
	[X,Y,DataOK]= FitData(mdev);
	
	% data already not flagged bad for Y
	f= find(DataOK);
	
	% only 'good' data is displayed in RegPlots
	% so index to outliers from RegPlot (ud.index) needs to be
	% refenced to good data index,
	NewOutliers= f(ind);
	
	p= Parent(mdev);
	mldev= p.mle_ApplyOutliers(rfindex(mdev),NewOutliers);
	mldev=status(mldev,0);

	
	mbH=MBrowser;
	if mbH.GUIExists
		mbH.doDrawText;
	end

end
