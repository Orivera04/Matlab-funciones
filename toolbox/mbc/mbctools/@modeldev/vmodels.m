function list=vmodels(mdev,ind)
%VMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:07 $

if nargin==2
   list= children(mdev,ind,'BestModel');
else
   list= children(mdev,'BestModel');
end