function [modellist,f]= getmodellist(U,nf);
% xregusermod/GETMODELLIST get list of registered models with nf factors;

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:01:12 $

if nargin < 2
	nf = 1;
end

mvmodelcfg= getpref(mbcprefs('mbc'),'usermodels');

n= length(mvmodelcfg.models);
nfacts=zeros(n,1);
for i=1:n
	% make the models
   f= which(sprintf('%s(U)',mvmodelcfg.models{i}));
   if ~isempty(f)
      m= xregusermod('name',mvmodelcfg.models{i});
      nfacts(i)= nfactors(m)==nf;
   end
end
nfacts= (nfacts~=0);

modellist= mvmodelcfg.models(nfacts);
f=[];
if ~isempty(modellist)
   f= find(strcmp(name(U),modellist));
   if isempty(f);
      f=1;
   end
end