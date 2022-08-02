function mdev=InitStore(mdev,ind);
% MODELDEV/INITSTORE initialises model for fast statistic calculation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:36 $


[X,Y]= getdata(mdev);
[mdev.Model,OK]= InitModel(mdev.Model,X,Y,[],0);

pointer(mdev);
