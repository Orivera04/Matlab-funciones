function [Feats,Defaults,Values]= features(f);
% POLYPLINE/FEATURES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:08 $


DelG= eye(sum(f.order));   

Display = {'knot',...
      'max'};
Names= {'knot',...
      'max'};
Function= {'p(1)',...
      'p(2)'};
delG= {['[',sprintf('%d ',DelG(1,:)),']'],...
      ['[',sprintf('%d ',DelG(2,:)),']']};
IsDatum = {1 0};

Feats= struct('Display',Display,...
      'Function',Function,...
      'delG',delG,...
      'Name',Names,...
      'IsDatum',IsDatum);
      
for i=2:f.order(1)
   p=i+1;
   Feats(p)= struct('Display',sprintf('Bh%d',i),...
      'Function',sprintf('p(%1d)',p),...
      'delG',['[',sprintf('%d ',DelG(p,:)),']'],...
      'Name',sprintf('Bhigh_%d',i),...
      'IsDatum',0);
end

for j=2:f.order(2)
   p= f.order(1)+j;
   Feats(p)= struct('Display',sprintf('Blow%d',j),...
      'Function',sprintf('p(%d)',p),...
      'delG',['[',sprintf('%d ',DelG(p,:)),']'],...,...
      'Name',sprintf('Blow_%d',j),...
      'IsDatum',0);
end

[Feats.index]= deal(0);
[Feats.IsLinear]= deal(1);


delG= ['[0 x2fxlin(f,f.Values(i))]-' ['[', sprintf('%d ',DelG(2,:)), ']' ]];

Feats= [Feats,...
   struct('Display','f(x+knot) - f(knot)',...
      'Function','eval(f,f.Values(i))-p(2)',...
      'delG',delG,...
      'Name','df',...
      'IsDatum',0,...
		'index',0,...
		'IsLinear',1),...
      features(f.localmod)];
% localmod
ind= num2cell(1:length(Feats));
[Feats.index]= deal(ind{:});
[Feats.IsLinear]= deal(1);

if nargout==3
   Defaults=[1:size(f,1)];
   Values= zeros(size(f,1),1);
end
   