function i=getprefsinfo(p)
% GETPREFSINFO  Return a list of available preferences
%
%  LIST=GETPREFSINFO(p) returns a cell array of the available 
%  preferences in the current set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:44:57 $

% Created 6/3/2001

i=pr_datastore('prefsinfo');
return