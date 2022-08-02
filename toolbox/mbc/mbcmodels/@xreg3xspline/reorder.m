function val=reorder(m);
% xreg3xspline/REORDER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:19 $


o3= reorder(m.cubic);
i=m.splinevar ;
o3(o3>=i)= o3(o3>=i)+1;
% insert spline variable in correct position
val = [i o3];
