function n= numSubModels(mdev);
% MDEV_LOCAL/NUMSUBMODELS number of submodels

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:04:59 $


L= model(mdev);
nf=numfeats(L);
n=size(L,1);
if nf>=n
   n= nchoosek(nf,n);
else
   n=0;
end
