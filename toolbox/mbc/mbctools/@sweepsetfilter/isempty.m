function out = isempty(obj);
%ISEMPTY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:09:01 $

if obj.pSweepset == 0
	out = 1;
else
	out = isempty(sweepset(obj));
end