function N = setBPunofficial(N,BP)
%SETBPUNOFFICIAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:06 $

% Sets the breakpoints without affecting history. We don't do any checks here
% so folks using this function had better make sure that the number of BP's they have 
% is the same as the number of values.

N.Breakpoints = BP;

return