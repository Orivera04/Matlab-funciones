function s=TSstatistics(mdev,newstats);
%TSSTATISTICS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:14 $

if nargin==1
   s= mdev.TSstatistics;
else
   mdev.TSstatistics= newstats;
   pointer(mdev);
   s= mdev;
end
   