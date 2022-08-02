function L=completecopymodel(L)
%LOCALMULTI/COMPLETECOPYMODEL
%
%  Transfer the model to contained models
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:39:52 $


L.xregmulti=completecopymodel(L.xregmulti);

[Bnds,g,Tgt]= getcode(L);
g(:)={''};
   
mdls= get(L.xregmulti,'models');
for n=1:length(mdls)
    mdls{n}= yinfo(mdls{n},yinfo(L));
    mdls{n}= xinfo(mdls{n},xinfo(L));
    [Bnds,g,t]= getcode(L);
    
    mdls{n}= setcode(mdls{n},Bnds,g,repmat(recommendedTgt(mdls{n}),[nfactors(L),1]));
    
    mdls{n}= set(mdls{n},'ytrans','');
end
L.xregmulti= set(L.xregmulti,'allmodels',mdls);

Tgt(:,1)=-Inf;
Tgt(:,2)= Inf;
L= setcode(L,Bnds,g,Tgt);

