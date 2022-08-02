function p=restoreoutliers(mdev,level,ind)
%RESTOREOUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:05:47 $



switch lower(level)
case 'recursive'
   % remove all selected outliers
   out= outliers(mdev);
case 'single'
	out= ind;
end

if ~isempty(out) 
	p= Parent(mdev);
	mldev= p.mle_ApplyOutliers(rfindex(mdev),out);
	mldev=status(mldev,0);
	p= address(mdev);
	mbH=MBrowser;
	if mbH.GUIExists
		mbH.doDrawText;;
	end
end
