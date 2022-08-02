function out=nfactors(obj,nf)
% NFACTORS  get/set number of factors in candidate set
%
%  NF=NFACTORS(OBJ)
%  OBJ=NFACTORS(OBJ,NF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:35 $


% Created 7/11/2000

if nargin>1
   old_nf=nfactors(obj.candidateset);
   if nf<old_nf
      % cut out some dims
      obj.griddims=obj.griddims(obj.griddims<=nf);
      obj.grid=nfactors(obj.grid,length(obj.griddims));
      obj.lattdims=obj.lattdims(obj.lattdims<=nf);
      obj.lattice=nfactors(obj.lattice,length(obj.lattdims));
   elseif nf>old_nf       
      % add some lattice dimensions
      obj.lattdims=[obj.lattdims,(old_nf+1):nf];
      obj.lattice=nfactors(obj.lattice,length(obj.lattdims));      
   end
   obj.candidateset=nfactors(obj.candidateset,nf);
   out=obj;
else
   out=nfactors(obj.candidateset);
end
return