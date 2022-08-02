function mdev= tidytree(mdev,mbH)
% MODELDEV/TIDYTREE removes unnecessary model nodes from tree

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:11:02 $




if mdev.BestModel==0
	children(mdev,'tidytree',mbH);
else
	ch=children(mdev);
	if isa(mdev.Model,'xregtwostage');
		% delete all but best local node
		ind= find(children(mdev)~=mdev.BestModel);
		for i=ind;
			mbH.treeview(ch(i),'remove');
		end
		children(mdev,ind,'delete');
		% tidy remaining best local model
		children(info(mdev),'tidytree',mbH);
	else
		for i=1:numChildren(mdev);
			mbH.treeview(ch(i),'remove');
		end
		% best model copied up tree so delete all kids
		children(mdev,'delete');
	end

end

mdev= info(mdev);