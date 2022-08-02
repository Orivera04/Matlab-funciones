function i=getfeatsinfo(p)
% GETFEATSINFO  Return a list of available features
%
%  LIST=GETFEATSINFO(p) returns a cell array of the available 
%  features in the current set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:44:55 $

% Created 6/3/2001

i=pr_datastore('featsinfo');
return