function data=getpref(p,pref)
% GETPREF  Get the data from preference field
%
%   DATA=GETPREF(P,PREF) gets the data from the entry
%   PREF in the current preference set.
%   If there is no such preference, an error is issued.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:44:56 $

% Created 16/6/2000

data = pr_datastore('getpref',pref);