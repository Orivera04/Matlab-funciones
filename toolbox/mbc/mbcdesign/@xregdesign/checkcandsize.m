function ok=checkcandsize(des)
% CHECKCANDSIZE  
%
%  OK=CHECKCANDSIZE(D) returns 0 if the candidate settings in D
%  could lead to a gigantic candidate set.  Too large a set causes
%  problems with constraints.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:16 $

% Created 4/8/2000


% potential constraint problems include:
%
% (1) Light constraints.  The number of design point indices within
%     the constraints is large. Each index takes 4 bytes to remember.
%     Large design sets are simply too big to remember.
% (2) Heavy constraints.  In this case the problem is running out of
%     integers to use as an index.  2^32-1 is the max number of design
%     points when constrained. 

% The arbitrary memory limit is 10 meg.  This corresponds to 2.5e6 index
% points.

nc=ncand(des,'unconstrained');
if (nc>2.5e6)
   ok=0;
else
   ok=1;
end
return
