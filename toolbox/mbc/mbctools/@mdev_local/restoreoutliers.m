function mdev=RestoreOutliers(mdev,SNo)
% This function will remove local regression points 
% from the outlier index.
%
% RESTOREOUTLIERS(mdev_loc,SNo)
%
% will restore all points in sweep SNo.
% It works by simply finding the record index
% for any bad data in sweep SNo, and passing that
% index into the ADDOUTLIER routine. This will remove
% any duplicate records from the outlier index.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:04 $


% Get the sweep data
Y=getdata(mdev,'Y');
YData=Y(:,:,SNo);

% find all bad data in that sweep
sweepindex=find(isbad(YData));

% calculates the index wrt all sweeps
Spos=tstart(Y);
RecInd=Spos(SNo) + sweepindex-1;

% Find bad data that has been selected with 'rubber box'
RecInd=setdiff(outliers(mdev),RecInd);

% update outlier field in modeldev object
mdev= ApplyOutliers(mdev,SNo,RecInd);

