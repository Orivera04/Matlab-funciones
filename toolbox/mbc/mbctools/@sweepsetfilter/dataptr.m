function p = dataptr(obj, pSweepset)
%DATAPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:42 $

if nargin == 1
	p = obj.pSweepset;
else
	obj.pSweepset = pSweepset;
	p = obj;
end