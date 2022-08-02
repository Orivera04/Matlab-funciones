function list= OutlierList(mdev);
% MODELDEV/OUTLIERLIST test number list for outliers

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:45 $

Y= double(getdata(mdev,'Y'));
list=find(isnan(Y));

TP= mdevtestplan(mdev);
Yr= TP.Y.info;
if length(Y)==size(Yr,3)
   tn= testnum(TP.Y.info);
   list= tn(list);
end
