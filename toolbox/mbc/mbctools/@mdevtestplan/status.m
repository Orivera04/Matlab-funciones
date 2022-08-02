function s=status(mdev,s,Climb)
% TESTPLAN/STATUS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:23 $

if nargin>1
	s= mdev;
else
   s= status(mdev.modeldev);
end
   
