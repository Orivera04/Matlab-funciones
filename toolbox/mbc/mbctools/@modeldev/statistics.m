function s= model(mdev,newstatistics);
%STATISTICS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:59 $

if nargin==1;
   s= mdev.Statistics;
else
   mdev.Statistics=newstatistics;
   pointer(mdev);
   s=mdev;
end
     