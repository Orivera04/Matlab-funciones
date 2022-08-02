function [p,I,J]= unique(p)
% XREGPOINTER/UNIQUE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:21 $

if nargout==1
	[p.ptr]= unique(p.ptr);
else
	[p.ptr,I,J]= unique(p.ptr);
end