function [Feats,Defaults,Values]= features(f);
% POLYNOM/FEATURES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:42:59 $

m= f.order;

% knots
n= length(f.knots);
for i=1:n
   Feats(i).Display = sprintf('Knot_%1d',i);
   Feats(i).Function= sprintf('invcode(f,p(%d))',i);
   Feats(i).delG    = sprintf('delknot(f,%d)',i);
   Feats(i).Name    = sprintf('Knot_%1d',i);
   Feats(i).IsDatum = 0;
   Feats(i).index= i;
   Feats(i).IsLinear= 0;
end
% other parameters
j=0;
tsstat= Terms(f);
for i=1:f.order
   if tsstat(i)
      j=j+1;
      Feats(n+j).Display = sprintf('B_%1d',f.order-i);
      Feats(n+j).Function= sprintf('p(%d)',j+n);
      Feats(n+j).delG    = sprintf('delparam(f,%d)',j+n);
      Feats(n+j).Name    = sprintf('B_%1d',f.order-i);
      Feats(n+j).IsDatum = 0;
      Feats(n+j).index    = n+j;
      Feats(n+j).IsLinear = 1;
   end
end
n= n+j;
for i=1:length(f.knots);
   Feats(n+i).Display = sprintf('B_s%1d',i);
   Feats(n+i).Function= sprintf('p(%d)',i+n);
   Feats(n+i).delG    = sprintf('delparam(f,%d)',i+n);
   Feats(n+i).Name    = sprintf('B_s%1d',i);
   Feats(n+i).IsDatum = 0;
   Feats(n+i).index    = n+i;
   Feats(n+i).IsLinear = 1;
end
n= n+length(f.knots);


%% set up features to be derivatives 1,2,...,order-1
%% note index=1 is left free
for i=1:f.order-1
    Fpoly(i).Display = ['f',repmat('''',1,i),'(x)'];
    Fpoly(i).Function= sprintf('eval(diff(f,%d),code(f,f.Values(i)))',i);
    Fpoly(i).delG    = sprintf('hermiteX(f,code(f,f.Values(i)),%d)',i);
    Fpoly(i).Name    = sprintf('D%1d',i);
    Fpoly(i).IsDatum = 0;
    Fpoly(i).index = n+i;
    Fpoly(i).IsLinear = 0;
end

Fval= struct('Display','f(x)',...
      'Function','eval(f,code(f,f.Values(i,:)))',...
      'delG','hermiteX(f,code(f,f.Values(i,:)))',...
      'Name','FX',...
      'IsDatum',0,...
		'index',n+f.order,...
		'IsLinear',0);

Feats= [Feats Fpoly Fval];



if nargout==3
   nk=length(f.knots);
   Defaults=[1:size(f,1)];
   Values= zeros(size(f,1),1);
end

