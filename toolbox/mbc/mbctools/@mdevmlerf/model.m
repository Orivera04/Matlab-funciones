function m= model(mdev,newm)
%MODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 08:05:43 $



if nargin==1
	m= mdev.Model;
else
	mdev.Model= newm;
	xregpointer(mdev);
	m= mdev;
end
