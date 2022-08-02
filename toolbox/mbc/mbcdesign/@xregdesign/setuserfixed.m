function des = setuserfixed(des, idx, isfixed)
%SETUSERFIXED Mark design points as fixed by the user
%
%  OUT = SETUSERFIXED(DES, IDX) marks the design points indicated by the
%  index IDX as being "fixed".  This means that the data should not be
%  edited or removed.
%  IDX can be either a vector of design point indices or a logical vector
%  the same length as the design.
%
%  OUT = SETUSERFIXED(DES, IDX, ISFIXED) specifies whether the indicated
%  points should be fixed (ISFIXED=true) or unfixed (ISFIXED=false). 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:07:45 $ 

if nargin<3
    isfixed = true;
end

flags = pGetFlags(des, 'FIXED');
flags(idx) = isfixed;
des = pSetFlags(des, 'FIXED', flags);
