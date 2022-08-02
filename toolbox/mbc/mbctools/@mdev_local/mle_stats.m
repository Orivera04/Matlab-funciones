function s=MLE_Stats(mdev,newstats)
%MLE_STATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:53 $

if nargin>1
   mdev.MLE= newstats;
   pointer(mdev);
   s=mdev;
else
   s= mdev.MLE;
end