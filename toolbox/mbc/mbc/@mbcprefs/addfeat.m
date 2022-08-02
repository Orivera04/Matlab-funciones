function addfeat(p,feat)
%ADDFEAT   Add a new feature
%
%  ADDFEAT(P,FEAT) adds a feature called FEAT to the
%  preferences object.  It is initialised to be 0.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:44:50 $

% Created 16/6/2000

ok=pr_datastore('addfeat',feat);

if ~ok
   error(['The feature "' feat '" could not be added.  Check it does not already exist']);
end

return