function p= allpointers(mdev);
% MODELDEV/ALLPOINTERS pointer to tree

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:09:59 $

p= address(mdev);
if isa(mdev.Y,'pointer');
   p= [p mdev.Y];
end
if isa(mdev.X,'pointer');
   p= [p mdev.X];
end



