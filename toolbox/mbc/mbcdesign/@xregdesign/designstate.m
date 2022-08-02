function st=designstate(des)
% DESIGN/DESIGNSTATE   Returns number defining current state
%
%   ST=DESIGNSTATE(D) returns a number indicating the current state
%   of the design data.  This number is incremented whenever the design
%   changes so it can be used to 'stamp' stored results.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:27 $

% Created 12/11/99

st=des.designstate;

return