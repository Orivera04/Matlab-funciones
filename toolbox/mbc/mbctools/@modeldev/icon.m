function [image,selim]= icon(mdev,type);
% MODELDEV/ICON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:29 $

im= icon(mdev.Model);


image= im(1);
selim= im(2);
if nargin==2 & strcmp(type,'best')
	selim= im(3);
elseif status(mdev)==2
	image= im(3);
end