function n = numfeats( c );
%NUMFEATS  Number of response features in constraint
%   N = NUMFEATS(C) is the number of response features required for using C
%   as a local boundary constraint.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:49 $ 

n = 2 * sum( variables( c ) );
