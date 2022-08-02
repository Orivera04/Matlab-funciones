function [image,selim]= icon(mdev,type);
% MDEV_LOCAL/ICON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:36 $

bm= BestModel(mdev);
if isempty(bm)
	L= model(mdev);
	im= icon(L);
else
	im= icon(bm);
end

image= im(1);
selim= im(2);
if nargin==2 & strcmp(type,'best')
	selim= im(3);
elseif status(mdev)==2
	image= im(3);
end



