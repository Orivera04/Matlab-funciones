function T= info(T);
% TREE/INFO gets dynamic copy of tree node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:51 $

if T.node==0
	p= pointer(T);
	T= p.info;
else
	T= [T.node.info];
end
