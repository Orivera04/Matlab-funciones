function  p=bestmdev(mdev);
% MODELDEV/BESTMDEV pointer to best mdev

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:00 $

if isempty(children(mdev))
   % best model is itself if it is at the bottom of the tree.
   p= address(mdev);
else
   p= mdev.BestModel;
end