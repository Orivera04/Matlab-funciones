function knots= nlparams(m)
%xregUniSpline/INIT_PARAM - returns parameters for optimisation
%
% [knots,lbound, ubound, alpha]= init_param(m,X,Y) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:42 $

knots= get(m.mv3xspline,'knots');
knots= knots(:);
