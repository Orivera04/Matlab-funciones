function [L,U]=range(M);
% Exportmodel \ range
% R = range(m)
% [L,U] = range(m)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:41 $
if nargout == 1
	L = M.ranges;
else
	L=M.ranges(1,:);
	U=M.ranges(2,:);
end