function rsdout=setoptimal(rsd,p,aug,del)
% DES_RESPSURF/SETOPTIMAL   Set opimisation parameters
%   D=SETOPTIMAL(D,P[,AUG[,DEL]]) sets the design object optimisation
%   parameters P - the number of lines to add for each iteration, 
%   AUG - the augmentation method (either 'random' or 'optimal'),
%   DEL - the deletion method (either 'random' or 'optimal').
%   Defaults are P=5, AUG='random' and DEL='optimal'.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:55 $

% Created 5/11/99

rsd.p=p;
if nargin>2
   rsd.augmentmethod=aug;
   if nargin>3
      rsd.deletemethod=del;
   end
end

if ~nargout
   nm=inputname(1);
   assignin('caller',nm,rsd);
else
   rsdout=rsd;
end

return
