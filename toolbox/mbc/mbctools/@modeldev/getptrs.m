function p= getptrs(mdev);
% MODELDEV/GETPTRS list of internal pointers 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:22 $

p= address(mdev);
if isa(mdev.Y,'xregpointer');
   p= [p mdev.Y];
end
if isa(mdev.X,'xregpointer');
   p= [p mdev.X];
end



