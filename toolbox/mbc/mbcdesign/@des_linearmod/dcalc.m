function [psi,smod]=dcalc(smod,ReCalc)
% DES_LINEARMOD/DCALC  D-optimal value
%   PSI=DCALC(D) returns the d-optimality value for the
%   design object D.
%   See also: VCALC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:16 $

% Created 3/11/99

if ~rankcheck(smod)
   psi=[];
   return
end

if nargin==1
   ReCalc=0;
end
% search store for a valid copy
if ~ReCalc & isfield(smod.store,'dpsi')
   % psi depends on design but not candidate set
   if smod.store.dpsi.designstate==designstate(smod) & smod.store.dpsi.modelstate==modelstate(smod)
      psi=smod.store.dpsi.data;
      return
   end
end

if npoints(smod)
   % D-optimality is log(det(X'X))/k
   X=CalcJacob(model(smod),factorsettings(smod));
   [Q R]=qr(X,0);
   
   psi=(2*sum(log(abs(diag(R)))))./(size(X,2));
else
   psi=[];
end

% store result
smod.store.dpsi.data=psi;
smod.store.dpsi.designstate=designstate(smod);
smod.store.dpsi.candstate=candstate(smod);
smod.store.dpsi.modelstate=modelstate(smod);

nm=inputname(1);
if ~isempty(nm)
   assignin('caller',nm,smod);
end

return

