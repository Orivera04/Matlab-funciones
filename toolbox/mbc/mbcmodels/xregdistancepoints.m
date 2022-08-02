function d = xregdistancepoints(X, Y)
%XREGDISTANCEPOINTS Return matrix of distances between points
%
%  D = XREGDISTANCEPOINTS(X, Y) generates a matrix containing the distance
%  between each point in X and Y.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:31:04 $ 

d = mx_rbfeval( 'distance', Y', X', [], [] );
