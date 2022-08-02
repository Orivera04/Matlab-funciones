function addpref(p,pref)
% ADDPREF  Add a preference to the current preference set
%
%  ADDPREF(P,PREFNAME) adds a new preference called PREFNAME and
%  initialises it with empty data.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:44:51 $

% Created 16/6/2000

ok=pr_datastore('addpref',pref);
if ~ok
   error(['The preference "' pref '" could not be added.  Check it does not already exist']);
end
return