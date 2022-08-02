function out=nfactors(obj,nf)
% NFACTORS  get/set number of factors in candidate set
%
%  NF=NFACTORS(OBJ)
%  OBJ=NFACTORS(OBJ,NF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:45 $


% Created 16/11/2000

if nargin>1
   old_nf=nfactors(obj.candidateset);
   if nf<old_nf
      % cut out some dims
      if ~isempty(obj.indices)
         obj.indices=obj.indices(:,1:nf);
      end
   elseif nf>old_nf       
      % add some lattice dimensions
      if ~isempty(obj.indices)
         sz=size(obj.indices,1);
         for n=old_nf+1:nf
            obj.indices(:,n)=randperm(sz)';
         end
      end
   end
   obj.candidateset=nfactors(obj.candidateset,nf);
   % redo delta
   lims=limits(obj.candidateset);
   obj.delta=(diff(lims,1,2)')./obj.N;  
   out=obj;
else
   out=nfactors(obj.candidateset);
end
return
