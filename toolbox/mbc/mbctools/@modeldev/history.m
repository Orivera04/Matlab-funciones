function out= history(mdev,event);
% MODELDEV/HISTORY manage internal history of mdev objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:28 $

if nargin==1
   mdev.History= mdev;
   out=mdev;
   pointer(mdev);
else
   switch lower(event)
   case 'get'
      out= mdev.History;
   case 'clear'
      mdev.History= [];  
      pbest = mdev.BestModel;
      if isa(mdev.Model,'xregtwostage') & pbest~=0
         pbest.history('clear');
      end
      pointer(mdev);
      out=mdev;
   end
end
