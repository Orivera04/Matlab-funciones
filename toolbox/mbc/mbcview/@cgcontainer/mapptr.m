function T= mapptr(T,RefMap);
% CGCONTAINER/MAPPTR 
% 
% nd= mapptr(nd,RefMap);
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:21:58 $

% if T.data is pointer, change our reference.  If it isn't then pass
% on the call to the object in T.data.
if isa(T.data,'xregpointer')
   T.data=mapptr(T.data,RefMap);
end
T.cgnode=mapptr(T.cgnode,RefMap);