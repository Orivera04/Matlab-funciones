function [list,f]= getmodellist(U,nf);
% xregusermod/GETMODELLIST get list of registered models with nf factors;

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:58:53 $


cfg= getpref(mbcprefs('mbc'),'dynamic');

n= length(cfg.models);
if nargin>1
   nfacts=zeros(n,1);
   for i=1:n
		m= xregtransient('name',cfg.models{i});
      nfacts(i)= nfactors(m)==nf;
   end
   nfacts= (nfacts~=0);
else
   nfacts=true(n,1);
end

list=cfg.models(nfacts);
f=[];
if ~isempty(list)
   f= find(strcmp(name(U),list));
   if isempty(f);
      f=1;
   end
end