function out=nfactors(obj,nf)
% NFACTORS  get/set number of factors in candidate set
%
%  NF=NFACTORS(OBJ)
%  OBJ=NFACTORS(OBJ,NF)
%  
%  NOTE: this method should be overloaded by all cset objects to
%  capture and deal with the setting of a new number of factors.
%  (Getting nfactors is fine from here).
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:56:04 $

% Created 1/11/2000

if nargin>1
   old_nf=size(obj.lims,1);
   if nf<old_nf
      obj.lims=obj.lims(1:nf,:);
   elseif nf>old_nf
      obj.lims(old_nf+1:nf,:)=repmat([-1 1],(nf-old_nf),1);      
   end
   out=obj;
else
   out=size(obj.lims,1);
end
return