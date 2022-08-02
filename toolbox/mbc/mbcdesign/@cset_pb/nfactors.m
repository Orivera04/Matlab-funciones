function out=nfactors(obj,nf)
% NFACTORS  get/set number of factors in candidate set
%
%  NF=NFACTORS(OBJ)
%  OBJ=NFACTORS(OBJ,NF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:56 $


% Created 16/11/2000

if nargin>1
   old_nf=nfactors(obj.candidateset);
   if nf>old_nf       
      % check the current number of rows can handle this number of factors
      if obj.Nr<=nf
         Nrvect=pr_getrunopts(nf);
         obj.Nr = Nrvect(1);
      end
   end
   obj.candidateset=nfactors(obj.candidateset,nf);
   out=obj;
else
   out=nfactors(obj.candidateset);
end
return