function Type= NodeType(mdev);
% MODELDEV/NODETYPE 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:41 $

p= Parent(mdev);
if p==0
   Type= 'Project';
else
   Type= p.ChildType(childindex(mdev));
end
