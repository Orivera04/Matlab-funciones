function mdev=delchild(mdev,chindex);
% MODELDEV/DELCHILD cleans up deletion of child at chindex

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:10 $

ch= children(mdev);
if isempty(ch) | ~any(ch==mdev.BestModel)
   % reset bestmodel if deleted model was best
   mdev= BestModel(mdev,xregpointer);
end