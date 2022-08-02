function [mlist,name]= buildmodels(m,nobs);
% BUILDMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.8.2.2 $  $Date: 2004/02/09 07:58:15 $

[mink,maxk,ok]= ModelBuildGUI(m,'create',nobs);
if ok
   mlist= cell(1,maxk-mink+1);
   ind=1;
   for i=mink:maxk
      set(m,'max_knots',i);
      set(m,'numknots',i);
      
      mlist{ind}= m;
      ind = ind+1;
   end
   name= 'Free Knot Splines';
else
   name= '';
   mlist={};
end