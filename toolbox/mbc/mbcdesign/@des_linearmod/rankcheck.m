function OK=rankcheck(smod)
% RANKCHECK   Perform rank checking on design
%
%   OK=RANKCHECK(DES) returns 0 or 1, indicating whether the design
%   is rank-deficient or ok. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:44 $

% Created 3/12/99

if isfield(smod.store,'rankcheck')    
   % rank checking depends on model and design
   if (smod.store.rankcheck.designstate==designstate(smod)) & ...
         (smod.store.rankcheck.modelstate==modelstate(smod))
      OK=smod.store.rankcheck.data;
      return
   end
end

x=factorsettings(smod);
if ~isempty(x)
   X=CalcJacob(model(smod),x);
   [Q,R]=qr(X,0);
   
   if size(X,1)<size(X,2)
      OK=0;
      return;
   end
   rd= abs(diag(R));
   tol= length(X)*eps*max(rd);
   OK=  ~(size(X,2)>size(Q,1) | any(rd<tol));
else
   OK=0;
end

% attempt to place smod back into caller workspace
nm=inputname(1);
if ~isempty(nm)
   smod.store.rankcheck.data=OK;
   smod.store.rankcheck.designstate=designstate(smod);
   smod.store.rankcheck.modelstate=modelstate(smod);
   assignin('caller',nm,smod);
end




