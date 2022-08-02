function i=getsetinfo(p)
% GETSETINFO  Return a list of available sets
%
%  LIST=GETSETINFO(p) returns a cell array of the available 
%  preference sets.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:44:58 $

% Created 6/3/2001

i=pr_datastore('setsinfo');
return