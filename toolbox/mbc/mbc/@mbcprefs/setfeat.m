function setfeat(p,feat,data)
% SETFEAT  Set data in a preference field
%
%   SETFEAT(P,FEAT,DATA) sets DATA into the field
%   FEAT in the current preference set.
%   If there is no such field as FEAT, an error is 
%   issued.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:21 $

% Created 16/6/2000

ok=pr_datastore('setfeat',feat,data);
if ~ok
   error(['Set failed: feature "' feat '" not found.']);
end
return