function m= xregstatsmodel(mdev)
% MODELDEV/XREGSTATSMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:08 $

m= model(mdev);
n= name(mdev);;
% boundary model
cmodel= BoundaryModel(mdevtestplan(mdev),m);

INFO= exportinfo( info(project(mdev)) ,address(mdev),{m});
m= xregstatsmodel(m,n,INFO,cmodel);
