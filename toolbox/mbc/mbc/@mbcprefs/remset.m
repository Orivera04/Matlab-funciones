function remset(p)
%REMSET  Remove a preference set
%
%   REMSET(P) removes the current preference set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:18 $

% Created 16/6/2000

ok=pr_datastore('remprefset');
if ~ok
   error(['Error during preference set removal.']);
end
