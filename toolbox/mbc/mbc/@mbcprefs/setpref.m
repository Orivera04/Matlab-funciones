function setpref(p,pref,data)
% SETPREF  Set data in a preference field
%
%   SETPREF(P,PREF,DATA) sets DATA into the field
%   PREF in the current preference set.
%   If there is no such field as PREF, an error is 
%   issued.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:22 $

% Created 16/6/2000

ok=pr_datastore('setpref',pref,data);
if ~ok
   error(['Set failed: preference "' pref '" not found.']);
end
return