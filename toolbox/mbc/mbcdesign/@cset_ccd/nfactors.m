function out=nfactors(obj,nf)
% NFACTORS  get/set number of factors in candidate set
%
%  NF=NFACTORS(OBJ)
%  OBJ=NFACTORS(OBJ,NF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:13 $


% Created 16/11/2000

if nargin>1
   old_nf=nfactors(obj.candidateset);
   if nf<old_nf
      % cut out some dims
      obj.Alpha=obj.Alpha(1:nf);
   elseif nf>old_nf       
      % add some dimensions
      if all(obj.Alpha==1)
         obj.Alpha(old_nf+1:nf)=1;   % Face center cube
      elseif all(abs(obj.Alpha-sqrt(old_nf))<1e-10)
         val=sqrt(nf);     % Spherical
         obj.Alpha(1:nf)=val;
      else
         val=nf^0.25;       % custom: set to possible rotatable value
         obj.Alpha(old_nf+1:nf)=val;
      end
   end
   obj.candidateset=nfactors(obj.candidateset,nf);
   out=obj;
else
   out=nfactors(obj.candidateset);
end
return