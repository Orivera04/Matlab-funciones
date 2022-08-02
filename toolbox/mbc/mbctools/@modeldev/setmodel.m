function mdev = setmodel(mdev,m,OK);
% MODELDEV/SETMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:10:56 $



mdev.Model= m;
mdev= InitStore(mdev);
[X,Y]= getdata(mdev);
[X,Y]= checkdata(m,X,Y);
mdev.Statistics= FitSummary(m,X,Y);

mdev= status(mdev,OK);
