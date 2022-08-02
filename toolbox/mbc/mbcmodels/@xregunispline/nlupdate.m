function m= nlupdate(m,p);
% xregUniSpline/NLUPDATE update of nonlinear parameters

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:43 $

m.mv3xspline= set(m.mv3xspline,'knots',p);