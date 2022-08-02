function out= rfoutliers(mdev,ind);
% MODELDEV/RFOUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:10:52 $

if nargin==1
    out= mdev.Outliers;
else
    mdev.Outliers= ind;
    xregpointer(mdev);
    out=mdev;
end
    