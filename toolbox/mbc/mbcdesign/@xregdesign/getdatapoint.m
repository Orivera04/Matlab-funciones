function flags = getdatapoint(des)
%GETDATAPOINT Return list of points that are data points
%
%  FLAGS = GETDATAPOINT(DES) returns a logical vector indicating which
%  points have been marked as data points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:06:37 $ 

flags = pGetFlags(des, 'DATA');