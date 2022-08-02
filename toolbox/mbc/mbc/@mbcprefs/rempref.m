function rempref(p,pref)
% REMPREF  Remove a preference
%
%   REMPREF(P,PREF) removes the preference PREF from
%   the current preference set.  If the preference does
%   not exist there is no error.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:17 $

% Created 16/6/2000

pr_datastore('rempref',pref);
return