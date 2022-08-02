function ret = ispref(p,pref)
%ISPREF  Test for existence of preference
%
%   OUT = ISPREF(P,PREF) returns 1 if PREF is a valid
%   preference name for the current preference set, 0
%   otherwise.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:01 $

% Created 16/6/2000

ret=pr_datastore('ispref',pref);
return