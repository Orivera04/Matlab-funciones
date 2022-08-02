function rej=pcreject(des)
% PCREJECT   Percentage rejection of candidates
%
%   R=PCREJECT(D) returns the percentage of candidate points
%   rejected by the constraints.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:20 $

% Created 4/1/2000

rej=100*(1-(ncand(des)./ncand(des,'unconstrained')));