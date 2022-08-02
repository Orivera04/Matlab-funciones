function st=candstate(des)
% DESIGN/CANDSTATE   Returns number defining current state
%
%   ST=CANDSTATE(D) returns a number indicating the current state
%   of the candidate set.  This number is incremented whenever the set
%   changes so it can be used to 'stamp' stored results.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:14 $

% Created 12/11/99

st=des.candstate;

return