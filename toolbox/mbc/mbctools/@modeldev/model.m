function m= model(mdev,newmodel);
%MODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:38 $

if nargin==1;
   m= mdev.Model;
else
   mdev.Model=newmodel;
   %mdev=modelinfo(mdev);
   pointer(mdev);
   m=mdev;
end
     