function [psi,des]=acalc(des,ReCalc)
% DES_MULTIMOD/ACALC  A-optimal value
%   PSI=ACALC(D) returns the v-optimality value for the
%   design object D.
%   See also: DCALC, VCALC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:32 $


if ~rankcheck(des)
   psi=[];
   return
end

% search store for a valid copy
if nargin==1
   ReCalc=0;
end
if ~ReCalc & isfield(des.store,'apsi')    
   % psi depends on design
   if (des.store.apsi.designstate==designstate(des)) & ...
         (des.store.apsi.modelstate==modelstate(des))
      psi=des.store.apsi.data;
      return
   end
end

if npoints(des)
   mmdl=model(des);
   % A-optimality is weighted sum of trace(inv(X'X))
   mdls=get(mmdl,'models');
   wts=get(mmdl,'weights');
   % weights are already guaranteed to sum to 1 by the multimod object
   psi=0;
   fs=factorsettings(des);
   for n=1:length(wts)
      mdls{n} = InitStore(mdls{n},fs);
      Ai = cov(mdls{n});
      psi = psi+wts(n).*sum(diag(Ai));
   end
else
   psi=[];
end


% store result
des.store.apsi.data=psi;
des.store.apsi.designstate=designstate(des);
des.store.apsi.modelstate=modelstate(des);

if nargout<2
   nm=inputname(1);
   if ~isempty(nm)
      assignin('caller',nm,des);
   end
end
return