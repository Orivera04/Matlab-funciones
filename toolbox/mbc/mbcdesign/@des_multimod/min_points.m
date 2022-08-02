function n=min_points(des)
%MIN_POINTS   Return the minimum number of points for a design
%
%   N=MIN_POINTS(DES) returns the minimum number of points necessary
%   to allow a design to pass the rankcheck test.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:40 $

% Created 25/5/2000


% start at number of terms in model, then try increasing/decreasing

% start guess needs to know the number of terms in the biggest model
np=get(model(des),'maxterms');
des=reinit(des,np);

if npoints(des)
   % try taking a point off
   rc=rankcheck(des);
   while rc
      des=delete(des,'random',1);
      rc=rankcheck(des);
   end
   n=npoints(des)+1;
else
   n=1;
   while ~npoints(des) & n<=3*np
      des=reinit(des,np+n);
      n=n+1;
   end
   if npoints(des)
      n = npoints(des); 
   else
      % minimum  not found
      n = [];
   end
end