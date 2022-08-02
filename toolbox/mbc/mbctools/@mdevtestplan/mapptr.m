function T= mapptr(T,RefMap);
% TESTPLAN/MAPPTR 
% 
% mdev= mapptr(mdev,RefMap);
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:58 $


T.DataLink     = mapptr(T.DataLink,RefMap);


T.ConstraintData = mapptr( T.ConstraintData, RefMap );

T.modeldev=mapptr(T.modeldev,RefMap);
