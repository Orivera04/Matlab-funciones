function openset(p,nm)
% OPENSET  Open a preference set
%
%   OPENSET(P,NM) opens the preference set NM.  The current
%   preference set is saved beforehand.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:08 $

% Created 16/6/2000

if pr_datastore('isprefset',nm)
   pr_datastore('changeprefset',nm);
else
   error(['Open Set failed: "' nm '" is not a Preference Set name.']);
end
