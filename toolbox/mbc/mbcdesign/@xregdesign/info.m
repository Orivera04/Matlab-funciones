function [inf,w]=info(des)
%INFO  Return design information
%
%  INF=INFO(DES) returns information for the design
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:01 $



inf={'Design Style',getstyleinfo(des);...
      'Number of Points',sprintf('%d',npoints(des));...
      'Number of Constraints', sprintf('%d',numConstraints(des));...
      'Last Changed', [datestamp(des), ', ', timestamp(des)];...
      'Model',name(model(des));...
   };
w=[80 50 50 120 150];  

[st,stinfo]=getstyle(des);
if st==2
   inf=[inf; {'Discrepancy',sprintf('%f',discrep(stinfo));...
            'Minimum point-point distance',sprintf('%f',mindist(stinfo));...
            'Maximum point-point distance',sprintf('%f',maxdist(stinfo))}];
   w=[w 50 50 50];   
end
