function obj=getdesign(rsd)
% DES_RESPSURF/GETDESIGN   Get a complete design object
%   DESOBJ=GETDESIGN(D) returns the basic design object that
%   is the parent of the response surface design.  
%   See also:  SETDESIGN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:33 $

% Created 5/11/99


obj=rsd.xregdesign;

return


