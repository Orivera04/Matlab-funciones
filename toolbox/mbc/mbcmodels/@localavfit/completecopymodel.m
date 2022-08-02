function L = completecopymodel( L )
%LOCALAVFIT/COMPLETECOPYMODEL   Model copy completion for LOCALAVFIT
%   M= COMPLETECOPYMODEL(M) performs model specific copy actions on the new 
%   XREGARX model M.
%
%   See also XREGMODEL/COPYMODEL, XREGMODEL/COMPLETECOPYMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:37:35 $


L.model= yinfo(L.model,yinfo(L));
L.model= xinfo(L.model,xinfo(L));
[Bnds,g,t]= getcode(L);

L.model= setcode(L.model,Bnds,g,repmat(recommendedTgt(L.model),[nfactors(L),1]));


%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
