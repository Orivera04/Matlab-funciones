function nm=getsetname(p)
%GETSETNAME  Get the name of current Preference Set
%
%   NM=GETSETNAME(P) returns the name of the current preferences
%   set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:44:59 $

% Created 16/6/2000

nm=pr_datastore('getprefsetname');
return