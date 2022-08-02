function mdev= mapptr(mdev,RefMap);
% MODELDEV/MAPPTR 
% 
% mdev= mapptr(mdev,RefMap);
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:35 $

% ydata
switch class(mdev.Y)
case {'xregpointer','sweepsetfilter'}
   mdev.Y= mapptr(mdev.Y,RefMap);
case 'struct'
   mdev.Y.ptr= mapptr(mdev.Y.ptr,RefMap);
end

% xdata
switch class(mdev.X)
case 'xregpointer'
	for i=1:length(mdev.X)
		mdev.X(i)= mapptr(mdev.X(i),RefMap);
	end
case 'struct'
   mdev.X.ptr= mapptr(mdev.X.ptr,RefMap);
end

% datum links
mdev.Data= mapptr(mdev.Data,RefMap);

% bestmodel
if isa(mdev.BestModel,'xregpointer');
   mdev.BestModel= mapptr(mdev.BestModel,RefMap);
end

% kids and parent
mdev.mctree= mapptr(mdev.mctree,RefMap);