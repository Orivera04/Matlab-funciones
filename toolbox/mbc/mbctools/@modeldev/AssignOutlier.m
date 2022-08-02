function varargout= AssignOutlier(mdev,ind);
%ASSIGNOUTLIER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:22 $

N= length(getdata(mdev,Y));
GoodData= 1:N;
% data already not flagged bad for Y
GoodData(mdev.Outliers)=[];

% only 'good' data is displayed in RegPlots
% so index to outliers from RegPlot (ud.index) needs to be
% refenced to good data index,
NewOutliers= GoodData(ind);

mdev.Outliers = union(mdev.Outliers,NewOutliers);


if nargout>0
   varargout{1}=mdev;
else
   % Update Heap copy of mdev
   pointer(mdev);
end



