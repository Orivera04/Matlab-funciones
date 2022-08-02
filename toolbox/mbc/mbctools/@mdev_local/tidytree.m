function mdev= tidytree(mdev,mbH)
%TIDYTREE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:05:13 $



if ~isempty(BestModel(mdev))
	ind = mdev.ResponseFeatures(1,:);
	RF1= RFstart(model(mdev));
	if RF1
		ind= [1 1+ind];
	end
	% tidy best response features
	children(mdev,ind,'tidytree',mbH);
	mdev= info(mdev);
	% delete other response features
	delind= setdiff(1:numChildren(mdev),ind);
	ch=children(mdev);
	for i=delind;
		mbH.treeview(ch(i),'remove');
	end
	children(mdev,delind,'delete');

else
	% tidy response feature models
	children(mdev,'tidytree',mbH);
end

mdev= info(mdev);
