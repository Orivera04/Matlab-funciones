function [psi,smod]=vcalc(smod,ReCalc)
% DES_LINEARMOD/VCALC  V-optimal value
%   PSI=VCALC(D) returns the v-optimality value for the
%   design object D.
%   See also: DCALC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:49 $

% Created 8/11/99

if ~rankcheck(smod)
   psi=[];
   return
end

% search store for a valid copy
if nargin==1
   ReCalc=0;
end
if ~ReCalc & isfield(smod.store,'vpsi')    
   % psi depends on design and candidate sets
   if (smod.store.vpsi.designstate==designstate(smod)) & (smod.store.vpsi.candstate==candstate(smod)) & ...
         (smod.store.vpsi.modelstate==modelstate(smod))
      psi=smod.store.vpsi.data;
      return
   end
end

% V-optimality is trace(Ainv*(sum(x'x)/nx))
fs=factorsettings(smod);

% calc it ourselves then
K=sumxtx(smod);
m = InitStore(model(smod),fs);
Ai= cov(m);
psi=sum(Ai(:).*K(:));


% store result
smod.store.vpsi.data=psi;
smod.store.vpsi.designstate=designstate(smod);
smod.store.vpsi.candstate=candstate(smod);
smod.store.vpsi.modelstate=modelstate(smod);

if nargout<2
   nm=inputname(1);
   if ~isempty(nm)
      assignin('caller',nm,smod);
   end
end
return