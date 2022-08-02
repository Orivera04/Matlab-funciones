function mergeprefs(ap,file,type,pref)
% MERGEPREFS   Bring in new prefs from another file
%
%   MERGEPREFS(AP,FILE,TYPE,NAME) merges in data from a
%   new file.  
%       FILE is the filename of the new prefs file
%       TYPE is either 'pref' or 'feat'.
%       NAME is the name of the changed preference or feature
%
%   Note that the preferences in memory are update.  Execute
%   saveprefs to save the changes back to the main file.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:07 $

% Created 1/9/2000

pr_datastore('merge',file,type,pref);
return
