function [y,p]= reconstruct(u,Yrf,x,dat);
% USERLOCAL/RECONSTRUCT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:01 $


rfindex= get(u,'feat.index');
np= numParams(u.userdefined);
if any(rfindex>np)
   dG= delG(u);
   p= reconstruct(u.userdefined,Yrf,dG,rfindex);
else
   % parameters are just a rearrangement of rf's
   [s,i]= sort(rfindex);
   p=Yrf(:,i);
end

if size(p,1)==1
   U= update(u.userdefined,p(:));
   y= eval(U,x);
else   
   y= zeros(size(x,1),1);
   for i=1:size(p,1);
      U= update(u.userdefined,p(i,:)');
      y(i)= eval(U,x(i,:));
   end
end
   