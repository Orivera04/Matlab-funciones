function T= mdevtestplan(mdev);
% MODELDEV/MDEVTESTPLAN finds the testplan associated with a modeldev node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:37 $

p= Parent(mdev);
while p~=0 & ~isa(mdev,'mdevtestplan')
	mdev= info(p);
	p= Parent(mdev);
end	

if isa(mdev,'mdevtestplan')
	T=mdev;
else
	error('No testplan for this node');
	T=[];
end

