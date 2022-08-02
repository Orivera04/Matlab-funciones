function OK= isGrowth(L);
% LOCALUSERMOD/ISGROWTH

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:17 $

ind= strcmp(name(L),GrowthModels(L));
OK=  any(ind);

