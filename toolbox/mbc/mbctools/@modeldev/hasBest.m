function has= hasBest(mdev);
% MODELDEV/HASBEST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:10:26 $

n= numChildren(mdev);
bm=  mdev.BestModel;
switch guid(mdev)
case 'global'
   has= (n==0 | (~isempty(bm) & bm~=0));
case 'twostage'
   has= (n~=0 & (~isempty(bm) & bm~=0));
end
