function addset(p,varargin)
% ADDSET  Add a new preference set
%
%   ADDSET(P,NM) adds a new preference set called NM.
%   ADDSET(P,NM,INITCMD) records INITCMD as the initialisation command
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 06:44:52 $

% Created 16/6/2000

nm=varargin{1};
if ~pr_datastore('isprefset',nm)
   pr_datastore('addprefset',varargin{:});
else
   error(['Add Set failed: "' nm '" is already in use by another Preference Set']);
end
return

