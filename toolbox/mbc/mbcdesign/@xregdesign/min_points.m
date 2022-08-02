function np=min_points(des)
%MIN_POINTS   Return the minimum number of points for a design
%
%   N=MIN_POINTS(DES) returns the minimum number of points necessary
%   to allow a design to pass the rankcheck test.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:08 $

% Created 24/3/2000


% start at 0 and increase until rankcheck is ok!

rc=0;
n=0;
des=reinit(des,0);
while rc==0
   rc=rankcheck(des);  
   des=augment(des,1);
end

np = npoints(des)-1;
