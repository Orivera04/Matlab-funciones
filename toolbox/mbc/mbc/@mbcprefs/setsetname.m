function setsetname(p,nm)
%SETSETNAME Set the name of a preference set
%
%  SETSETNAME(P,NM) sets the current preference set to have
%  the name NM.
%
%  Use ISSETNAME to check if NM has already been taken or not.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:23 $

% Created 16/6/2000

if ~pr_datastore('isprefset',nm)
   pr_datastore('setprefsetname',nm);
else
   error(['Set name failed: "' nm '" is already in use by another Preference Set']);
end
