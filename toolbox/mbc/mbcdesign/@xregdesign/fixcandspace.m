function des=fixcandspace(des)
% FIXCANDSPACE  Fix the candidate settings
%
%  D=FIXCANDSPACE(D) fixes the candidate settings so that
%  they are correct for the current number of design factors
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:34 $

% Created 19/5/2000

nfold=nfactors(des.candset);
nf=nfactors(model(des));
if nf~=nfold
   % set the nfactors in candset to fix it
   if nf>nfold
      lims=limits(des.candset);
      des.candset=nfactors(des.candset,nf);
		t= gettarget(model(des));
      lims(end+1:nf,1:2)=t(nfold+1:nf,1:2);
      des.candset=limits(des.candset,lims);
   elseif nfold>nf
      % just remove some dims
      des.candset=nfactors(des.candset,nf);
   end  
end
return