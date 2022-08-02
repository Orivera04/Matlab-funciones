function TS= pevinit(mdev,ind);
% MDEV_LOCAL/PEVINIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:01 $


if nargin>1
	TS= mdev.TwoStage{ind};
    sol= ind==1;
else
	if mle_best(mdev)
		TS= mdev.MLE.Model;
		sol= 0;
	else
		sol=1;
		TS= mdev.TwoStage{1};
	end
end

[Xg,Yrf,Sigma]= mledata(mdev,1);

TS= pevinit(TS,Xg,Yrf,Sigma,sol);
