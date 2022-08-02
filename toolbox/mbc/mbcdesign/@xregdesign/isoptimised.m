function ret=isoptimised(des)
% ISOPTIMISED  Query optimised state of object
%
%   OUT=ISOPTIMISED(D) returns 1 if the design D has had its
%   'lastoptimised' string set, 0 otherwise.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:04 $

% Created 16/2/2000

if ~isempty(des.lastoptimisation);
   ret=1;
else
   ret=0;
end

return
