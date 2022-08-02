function [OK, level] = isChild(obj, pParent)
%ISCHILD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:57 $

if ~isa(pParent, 'xregpointer') 
	error('isChild must be passed a pointer to an object');
end

OK = 0;
level = 0;
while (~isa(obj, 'sweepset') & ~OK)
	OK = obj.pSweepset == pParent;
	obj = obj.pSweepset.info;
	level = level + 1;
end
