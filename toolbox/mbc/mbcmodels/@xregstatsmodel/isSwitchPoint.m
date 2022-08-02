function ret = isSwitchPoint(m, X)
%ISSWITCHPOINT Check whether a point is a valid evaluation site
%
%  RET = ISSWITCHPOINT(M, X) where X is a (nPoints-by-nFactors) matrix of
%  evaluation points returns a logical vector of length nPoints containing
%  true where the corresponding evaluation point is a valid evaluation site
%  for the switched model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:57:52 $ 

ret = isSwitchPoint(m.mvModel, X);