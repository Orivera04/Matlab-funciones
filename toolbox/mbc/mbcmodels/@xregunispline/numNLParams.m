function n= numNLParams(m);
% xregUniSpline/numNLParams number of nonlinear parameters

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:44 $

n= get(m.mv3xspline,'numknots');