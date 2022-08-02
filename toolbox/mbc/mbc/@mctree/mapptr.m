function T= mapptr(T,RefMap);
% TREE/MAPPTR 
% 
% mdev= mapptr(mdev,RefMap);
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:57 $

T.node= mapptr(T.node,RefMap);
T.Parent= mapptr(T.Parent,RefMap);
T.Children= mapptr(T.Children,RefMap);
