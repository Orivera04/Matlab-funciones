function list= OutlierList(mdev);
% MODELDEV/OUTLIERLIST test number list for outliers

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:05:29 $

[X,Y,DataOK]= FitData(mdev);
list= unique([find(~DataOK);outliers(mdev)]);

TP= mdevtestplan(mdev);
Yr= getdata(TP,'Y');
if length(Y)==size(Yr,3)
   tn= testnum(Yr);
   list= tn(list);
end
