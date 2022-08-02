function m= reset(m);
% XREGRBF/RESET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:57:15 $

m= set(m,'fitalg','rbffit');
m= set(m,'lambda',1e-4);
m.xreglinear= reset(m.xreglinear);