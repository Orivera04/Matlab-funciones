function [psi,des]=dcalc(des,ReCalc)
% DES_MULTIMOD/DCALC  D-optimal value
%   PSI=DCALC(D) returns the d-optimality value for the
%   design object D.
%   See also: VCALC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:35 $

% Created 25/5/99

if ~rankcheck(des)
   psi=[];
   return
end

if nargin==1
   ReCalc=0;
end
% search store for a valid copy
if ~ReCalc & isfield(des.store,'dpsi')
   % psi depends on design but not candidate set
   if des.store.dpsi.designstate==designstate(des) & des.store.dpsi.modelstate==modelstate(des)
      psi=des.store.dpsi.data;
      return
   end
end
mmdl=model(des);

if npoints(des)
   % D-optimality is weighted sum of log(det(X'X))/k
   mdls=get(mmdl,'models');
   wts=get(mmdl,'weights');
   % weights are already guaranteed to sum to 1 by the multimod object
   psi=0;
   fs=factorsettings(des);
   for n=1:length(wts)
      X=CalcJacob(mdls{n},fs);
      [Q R]=qr(X,0);
      psi=psi+(2*wts(n).*sum(log(abs(diag(R)))))./(size(X,2));
   end
else
   psi=[];
end

% store result
des.store.dpsi.data=psi;
des.store.dpsi.designstate=designstate(des);
des.store.dpsi.candstate=candstate(des);
des.store.dpsi.modelstate=modelstate(des);

nm=inputname(1);
if ~isempty(nm)
   assignin('caller',nm,des);
end

return
