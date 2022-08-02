function OK= isequal(S1,S2);
% SWEEPSET/ISEQUAL 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:06:30 $

OK= 0;
if size(S1)==size(S2) & issubset(S1,S2);
	OK= 1;
end
