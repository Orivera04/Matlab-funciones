function mdev= mle_outliers(mdev,rf,ind);
%MLE_OUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:04:52 $


if nargin==3

	% toggle outliers
	mdev.MLE.Outliers(ind,rf)= ~mdev.MLE.Outliers(ind,rf);

	pointer(mdev);
elseif nargin==2
   Zind= [];
   % restore all outliers
   mdev.MLE.Outliers(:,rf)= false;
	pointer(mdev);
else
	mdev=mdev.MLE.Outliers;
end   

