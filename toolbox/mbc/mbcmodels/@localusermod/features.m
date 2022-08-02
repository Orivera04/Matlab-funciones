function [Feats,Defaults,Values]= features(f);
% USERLOCAL/FEATURES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:46 $

lab= labels(f);
np = length(lab);

lab= lab(:)';
func=lab;
dgfunc= lab;

% parameters as response features
for i=1:length(lab);
   lab{i}= strrep(lab{i},'\','');
   func{i}= sprintf('p(%d)',i);
   dgfunc{i}= sprintf('delparam(f,%d)',i);
end
Feats= struct('Display',lab,...
   'Function',func,...
   'delG',dgfunc,...
   'Name',lab,...
   'IsDatum',0,...
   'index',num2cell(1:np),...
	'IsLinear',1);

% possible userdefined 
[rf,dGl]= rfvals(f.userdefined);
[rnames,Defaults]= rfnames(f.userdefined);
for i= 1:length(rf)
   Feats(np+i)= struct('Display',rnames{i},...
      'Function',sprintf('rfvals(f,%d)',i),...
      'delG',sprintf('delrf(f,%d)',i),...
      'Name',rnames{i},...
      'IsDatum',0,...
      'index',np+i,...
		'IsLinear',0);
end

if nargout==3
   Values= zeros(np,nfactors(f));
end
   