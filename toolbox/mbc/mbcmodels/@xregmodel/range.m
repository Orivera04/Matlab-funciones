function [L,U,r]= range(m,reallim);
% MODEL/RANGE range of model 
% 
% [L,U,r]= range(m);
%   L Lower limit
%   U Upper limit
%   r range

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:54 $


   
c=m.code;
ws=warning;
warning off
for i=1:length(c)
   g= c(i).g;
   if ~isempty(g) & ~strcmp(char(g),'x')
      % invert min and max
      ginv = finverse( sym(g) );
      ginv = inline(ginv);
      c(i).min = ginv(c(i).min);
      c(i).max = ginv(c(i).max);
   end
end
warning(ws);
if ~isempty(c)
   L= [c.min];
   U= [c.max];
   if nargin>1 & reallim
      ind= L==-1 & U==1;
      L(ind)= -Inf;
      U(ind)= Inf;
   end
   r= U-L;
else
   nf= nfactors(m);
   L=-Inf*ones(1,nf);
   U= Inf*ones(1,nf);
   r= U;
end

   