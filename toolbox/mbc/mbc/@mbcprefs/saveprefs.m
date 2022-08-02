function ok=saveprefs(p)
% SAVEPREFS  Save preferences to disk
%
%  OK=SAVEPREFS(P) saves the current preference set to
%  its permanent storage on the HD.  OK indicates whether
%  the operation was successful or not.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:20 $

% Created 16/6/2000



ok=pr_datastore('save');
return