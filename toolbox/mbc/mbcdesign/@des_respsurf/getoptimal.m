function[p,aug,del]=getoptimal(rsd);
% DES_RESPSURF/GETOPTIMAL   Get optimisation settings
%   [P, AUG, DEL]=GETOPTIMAL(D) returns P, the number of lines
%   added during each iteration, AUG, the augmentation method used
%   and DEL, the deletion method used.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:34 $

% Created 5/11/99

p=rsd.p;
aug=rsd.augmentmethod;
del=rsd.deletemethod;

return