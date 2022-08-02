function X = getClosestSwitchPoint(m, X)
%GETCLOSESTSWITCHPOINT Return the closest valid evaluation point
%
%  XVALID = GETCLOSESTSWITCHPOINT(M, X) returns the evaluation point that
%  is closest to the input X.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:57:47 $ 

X = getClosestSwitchPoint(m.mvModel, X);