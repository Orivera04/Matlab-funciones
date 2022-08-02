function T= Parent(T)
% MCTREE/PARENT pointer to parent of tree

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:32 $



if T.node~=0;
   T= T.Parent;
else
   error('Tree is root')
end