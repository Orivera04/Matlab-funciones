function [psi,smod]=acalc(smod,ReCalc)
% DES_LINEARMOD/ACALC  A-optimal value
%   PSI=ACALC(D) returns the a-optimality value for the
%   design object A.
%   See also: DCALC, VCALC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:13 $

if ~rankcheck(smod)
   psi=[];
   return
end

% search store for a valid copy
if nargin==1
   ReCalc=0;
end
if ~ReCalc & isfield(smod.store,'apsi')    
   % psi depends on design 
   if (smod.store.apsi.designstate==designstate(smod)) & ...
         (smod.store.apsi.modelstate==modelstate(smod))
      psi=smod.store.apsi.data;
      return
   end
end

% V-optimality is trace(Ainv)
fs=factorsettings(smod);

% calc it ourselves then
m = InitStore(model(smod),fs);
Ai= cov(m);
psi=sum(diag(Ai));


% store result
smod.store.apsi.data=psi;
smod.store.apsi.designstate=designstate(smod);
smod.store.apsi.modelstate=modelstate(smod);

if nargout<2
   nm=inputname(1);
   if ~isempty(nm)
      assignin('caller',nm,smod);
   end
end
return