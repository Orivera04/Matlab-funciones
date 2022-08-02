function OK= deleteOK(mdev);
% MODELDEV/DELETEOK checks whether it is ok to delete this modeldev node
%
% this just checks whether it is a datumlink

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:11 $

allch= preorder(mdev,'address');
if isa(allch,'cell')
   allch= [allch{:}];
end
pdatum= datumlink(mdev);
OK= pdatum==0 | ~any(pdatum==allch);

Lp= Parent(mdev);
if OK & childindex(mdev)==1 & Lp.isa('mdev_local');
   % check whether you have a min (2) or max (1) datum 
   L= Lp.model;
   OK= ~ismember(DatumType(L),1:2);
end
