function out=nfactors(obj,nf)
% NFACTORS  get/set number of factors in candidate set
%
%  NF=NFACTORS(OBJ)
%  OBJ=NFACTORS(OBJ,NF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:18 $


% Created 12/3/2001

if nargin>1
   old_nf=nfactors(obj.candidateset);
   if nf<old_nf
      % cut out some dims
      obj.g= obj.g(1:nf);
      obj.Nlevels= obj.Nlevels(1:nf);
   elseif nf>old_nf       
      % add some lattice dimensions
      obj.g=[obj.g, i_createg(nf-old_nf,obj.N)];     
      obj.Nlevels=[obj.Nlevels, zeros(1,nf-old_nf)];
   end
   obj=doRealGCalc(obj);    % Update internal information
   obj.candidateset=nfactors(obj.candidateset,nf);
   out=obj;
else
   out=nfactors(obj.candidateset);
end
return



function g=i_createg(nf, N)
% create a vector of primes, g, all less than N and preferably different
g=primes(max(N/50,30));
g=g(5:end);
if length(g)<nf
   g=g(floor(rand(1,nf)*(length(g)))+1);
else
   g=g(randperm(length(g)));
   g=g(1:nf);
end