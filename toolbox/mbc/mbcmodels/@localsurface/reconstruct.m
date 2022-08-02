function [y,p]= reconstruct(u,Yrf,x,dat);
% USERLOCAL/RECONSTRUCT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:27 $


rfindex= get(u,'feat.index');
np= size(u,1);
if any(rfindex>np)
   dG = delG(u);
   p  = Yrf/dG';
else
   % parameters are just a rearrangement of rf's
   [s,i] = sort(rfindex);
   p     = Yrf(:,i);
end

pall = zeros(size(u.userdefined));
in   = linterms(u);



if size(p,1)==1
	pall(in)= p;
   u.userdefined= update(u.userdefined,pall);
   y= eval(u,x);
else   
   y= zeros(size(x,1),1);
   for i=1:size(p,1);
		pall(in)= p(i,:)';
		u.userdefined= update(u.userdefined,pall);
      y(i)= eval(u,x(i,:));
   end
end

   