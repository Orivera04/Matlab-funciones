function free(mdev)
% MODELDEV/FREE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:18 $

p= Parent(mdev);
if p.isa('mdev_local')
   % free response feature Y data
   free(mdev.Y);
end

   
