function q=qnow(rsd)
% QNOW   Return current q value from design
%
%   Q=QNOW(D) returns the curret value of the Q-counter from the design.
%   The Q-value is a measure of the number of times the optimisation
%   has failed to increase psi (as measured by delta) consecutively.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:53 $

% Created 28/3/2000

q=rsd.qnow;
return






