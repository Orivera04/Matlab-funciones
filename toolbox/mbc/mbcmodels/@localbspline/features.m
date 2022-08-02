function [Feats,Defaults,Values]= features(f);
% LOCALBSPLINE/FEATURES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:38:09 $

% knots
nk= get(f.xreg3xspline,'numknots');
for i=1:nk
   Feats(i).Display = sprintf('Knot_%1d',i);
   Feats(i).Function= sprintf('invcode(f,p(%d))',i);
   Feats(i).delG    = sprintf('delknot(f,%d)',i);
   Feats(i).Name    = sprintf('Knot_%1d',i);
   Feats(i).IsDatum = 0;
   Feats(i).index = i;
   Feats(i).IsLinear = 0;
end
% other parameters
j=0;
PHI= double(f.xreg3xspline);

for j=1:length(PHI)
   Feats(nk+j).Display = sprintf('B_%1d',j);
   Feats(nk+j).Function= sprintf('p(%d)',j+nk);
   Feats(nk+j).delG    = sprintf('delparam(f,%d)',j+nk);
   Feats(nk+j).Name    = sprintf('B_%1d',j);
   Feats(nk+j).IsDatum = 0;
   Feats(nk+j).index = nk+j;
   Feats(nk+j).IsLinear = 1;
end


[Feats.IsLinear]= deal(1);
% natural knots are not linear
[Feats(1:nk).IsLinear]= deal(0);

Fval= struct('Display','f(x)',...
      'Function','eval(f,code(f,f.Values(i,:)))',...
      'delG','hermiteX(f,code(f,f.Values(i,:)))',...
      'Name','FX',...
      'IsDatum',0,...
		'index',nk+length(PHI)+1,...
		'IsLinear',0);

Feats= [Feats Fval];

if nargout==3
   Defaults=[1:size(f,1)];
   Values= zeros(size(f,1),1);
end

