function varargout= AddOutliers(mdev,ind);
% MODELDEV/ADDOUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:58 $

Y= getdata(mdev,'Y');

% data already not flagged bad for Y
f= find(isfinite(double(Y)));

% only 'good' data is displayed in RegPlots
% so index to outliers from RegPlot (ud.index) needs to be
% refenced to good data index,
NewOutliers= f(ind);

mdev.Outliers = setxor(mdev.Outliers,NewOutliers);

pointer(mdev);

[OK,mdev]= fitmodel(mdev);

varargout= {mdev,OK};



