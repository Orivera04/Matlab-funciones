function mdev=delchild(mdev,chindex);
% MODELDEV/DELCHILD cleans up deletion of child at chindex

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:05:35 $

ch= children(mdev);
if isempty(ch) | ~any(ch==bestmdev(mdev))
   % reset bestmodel if deleted model was best
	mdev= setbest(mdev,xregpointer);
end
