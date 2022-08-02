function ss = applyVariables(obj)
%APPLYVARIABLES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:08:36 $


f = getFlags;
% Set only the apply variables modifier
ss = ApplyObject(obj, f.APPLY_VARS);
