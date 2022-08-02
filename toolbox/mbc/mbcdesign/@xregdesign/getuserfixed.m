function flags = getuserfixed(des)
%GETUSERFIXED Return list of points that have been fixed by the user
%
%  FLAGS = GETUSERFIXED(DES) returns a logical vector indicating which
%  points have been marked as fixed by the user.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:06:43 $ 

flags = pGetFlags(des, 'FIXED');