function ind= outliers(mdev,ind);
%OUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:44 $

if nargin>1
   mdev.Outliers = ind(:);
   ind=pointer(mdev);
else
   ind= mdev.Outliers;
end
