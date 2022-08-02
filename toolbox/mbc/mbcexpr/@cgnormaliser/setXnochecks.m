function LT = setXnochecks(LT,x);
%SETXNOCHECKS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:18 $

% Set the Xexpr field of the LUT to the expression x.
% Doesn't check that x points to something reasonable.
if isempty(x);
   LT.Xexpr = [];
end

LT.Xexpr = x;