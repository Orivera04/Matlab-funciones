function MP=setmodified(MP,mod)
%SETMODIFIED  Set a project as modified
%
% MP=setmodified(MP,mod) where mod is 0/1
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:51 $

% Created 18/4/2001


MP.Modified=mod;

pointer(MP);
return