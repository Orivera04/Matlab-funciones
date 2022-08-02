function ret=isoptimised(rsd)
% ISOPTIMISED  Query optimised state of object
%
%   OUT=ISOPTIMISED(D) returns 1 if the design D has optimised
%   flags corresponding to the current state of the object, 0
%   otherwise.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:45 $

% Created 16/2/2000

if (rsd.optimisedon.cand==candstate(rsd)) & ...
      (rsd.optimisedon.design==designstate(rsd)) & ...
      (rsd.optimisedon.model==modelstate(rsd))
   ret=1;
else
   ret=0;
end
return


