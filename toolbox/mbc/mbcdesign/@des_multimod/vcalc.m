function [psi,des]=vcalc(des,ReCalc)
% DES_MULTIMOD/VCALC  V-optimal value
%   PSI=VCALC(D) returns the v-optimality value for the
%   design object D.
%   See also: DCALC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:25 $

% Created 12/6/2000

if ~rankcheck(des)
   psi=[];
   return
end

% search store for a valid copy
if nargin==1
   ReCalc=0;
end
if ~ReCalc & isfield(des.store,'vpsi')    
   % psi depends on design and candidate sets
   if (des.store.vpsi.designstate==designstate(des)) & (des.store.vpsi.candstate==candstate(des)) & ...
         (des.store.vpsi.modelstate==modelstate(des))
      psi=des.store.vpsi.data;
      return
   end
end

% calc it ourselves then
K=sumxtx(des);

if npoints(des)
   mmdl=model(des);
   % D-optimality is weighted sum of log(det(X'X))/k
   mdls=get(mmdl,'models');
   wts=get(mmdl,'weights');
   % weights are already guaranteed to sum to 1 by the multimod object
   psi=0;
   fs=factorsettings(des);
   for n=1:length(wts)
      mdls{n} = InitStore(mdls{n},fs);
      Ai = cov(mdls{n});
      psi = psi+wts(n).*sum(Ai(:).*K{n}(:));
   end
else
   psi=[];
end


% store result
des.store.vpsi.data=psi;
des.store.vpsi.designstate=designstate(des);
des.store.vpsi.candstate=candstate(des);
des.store.vpsi.modelstate=modelstate(des);

if nargout<2
   nm=inputname(1);
   if ~isempty(nm)
      assignin('caller',nm,des);
   end
end
return