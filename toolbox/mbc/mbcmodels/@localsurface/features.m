function [Feats,Defaults,Values]= features(f);
% USERLOCAL/FEATURES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:42:06 $

lab= labels(f);
np = size(f,1);

lab= lab(:)';
func=lab;
dgfunc= lab;
in = linterms(f);

% parameters as response features
for i=1:np;
	lab{i} = sprintf('Beta_%s',strrep(lab{i},'\',''));
	func{i}= sprintf('p(%d)',i);
	dgfunc{i}= sprintf('delparam(f,%d)',i);
end
Feats= [struct('Display',lab,...
   'Function',func,...
   'delG',dgfunc,...
   'Name',lab,...
   'IsDatum',0,...
   'index',num2cell(1:np),...
	'IsLinear',1)];

Fval= struct('Display','f(x)',...
      'Function','eval(f,code(f,f.Values(i,:)))',...
      'delG','hermiteX(f,code(f,f.Values(i,:)))',...
      'Name','FX',...
      'IsDatum',0,...
		'index',length(Feats)+1,...
		'IsLinear',1);
Feats= [Feats Fval];

if nargout==3
   Defaults=[1:np];
   Values= zeros(np,nfactors(f));
end
   