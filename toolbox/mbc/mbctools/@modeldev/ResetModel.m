function mdev= ResetModel(mdev)
% MODELDEV/RESETMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:50 $

T= mdevtestplan(mdev);
m= mdev.Model;
mdev.Model=xinfo(model(T), xinfo(m));
mdev.Model=yinfo(mdev.Model, yinfo(m));
if ~isempty(strmatch(name(m),name(mdev)));
	% reset model name if necessary
	mdev= name(mdev,name(mdev.Model));
end
mdev.Outliers= [];
% refit model
[OK,mdev]= fitmodel(mdev);
