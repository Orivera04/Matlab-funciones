function out=nfactors(obj,nf)
% NFACTORS  get/set number of factors in candidate set
%
%  NF=NFACTORS(OBJ)
%  OBJ=NFACTORS(OBJ,NF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:24 $

% Created 30/12/2000

if nargin>1
   obj.grid=nfactors(obj.grid,nf);
   obj.candidateset=nfactors(obj.candidateset,nf);
   out=obj;
else
   out=nfactors(obj.candidateset);
end
return