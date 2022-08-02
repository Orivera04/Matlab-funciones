function [Target]= gettarget(m,index);
% MODEL/GETTARGET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:03 $

c=m.code;

if nargin==1;
   nf= nfactors(m);
   index= 1:nf;
end

ni=length(index);
Target=  zeros(ni,2);
if isempty(c)
   Target(:,1)=-1;
   Target(:,2)= 1;
else
   j=1;
   for i=index(:)'
      r= c(i).range;
      if isfinite(r)
         st = -(c(i).mid- c(i).min)/(c(i).max-c(i).min)*r;   
         Target(j,:)= [st st+r];
      else
        Target(j,:)= [c(i).min c(i).max];
      end
      j=j+1;
   end
end
