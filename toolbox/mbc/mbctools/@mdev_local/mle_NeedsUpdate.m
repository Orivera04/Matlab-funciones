function flag= mle_NeedsUpdate(mdev);
%MLE_NEEDSUPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:04:47 $



if ~isempty(BestModel(mdev)) & mle_best(mdev)
	L= model(mdev);
	st= children(mdev,'status');
	flag= sum([st{:}]==2)~=size(L,1)+RFstart(L);
else
	flag= 0;
end
