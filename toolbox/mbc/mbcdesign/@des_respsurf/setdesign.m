function rsd=setdesign(rsd,obj);
% DES_RESPSURF/SETDESIGN   Insert a new design object
%   D=SETDESIGN(D,DESOBJ) inserts the basic design object DESOBJ
%   as the parent of the current response surface design.
%   See also:  GETDESIGN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:54 $

% Created 5/11/99

if strcmp(class(obj),'xregdesign')
   rsd.xregdesign=obj;
end
return