function [Bnds,g,Target]= getcode(m,index);
% MODEL/GETCODE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:01 $

c=m.code;
ws=warning;
warning off

nf= nfactors(m);
if nargin==1;
   index= 1:nf;
end

ni=length(index);
Bnds= zeros(ni,2);
Target= Bnds;
if isempty(c)
   Bnds(:,1)=-1;
   Bnds(:,2)= 1;
   Target(:,1)=-1;
   Target(:,2)= 1;
   
   g= cell(ni,1);
else
   j=1;
   for i=index(:)'
      r= c(i).range;
      g= c(i).g;
      Bnds(j,:)= [c(i).min c(i).max];
      
      st = -(c(i).mid- c(i).min)/(c(i).max-c(i).min)*r;   
      Target(j,:)= [st st+r];
      
      if ~isempty(g) & ~strcmp(char(c(i).g),'x')
         % invert transform
         g=sym(c(i).g);
         ginv = finverse( g );
         ginv = inline(ginv);
         Bnds(j,:) = ginv(Bnds(j,:));
         
      end
      j=j+1;
   end
   % transforms
   g= {c(index).g};
end
warning(ws);
