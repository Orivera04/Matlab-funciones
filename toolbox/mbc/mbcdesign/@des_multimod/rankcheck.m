function OK=rankcheck(mmod)
% RANKCHECK   Perform rank checking on design
%
%   OK=RANKCHECK(DES) returns 0 or 1, indicating whether the design
%   is rank-deficient or ok. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:20 $

% Created 25/5/2000

% Multi-models must have every model passing the rankcheck!


if isfield(mmod.store,'rankcheck')    
   % rank checking depends on model and design
   if (mmod.store.rankcheck.designstate==designstate(mmod)) & ...
         (mmod.store.rankcheck.modelstate==modelstate(mmod))
      OK=mmod.store.rankcheck.data;
      return
   end
end

x=factorsettings(mmod);
if ~isempty(x)
   mdls=get(model(mmod),'models');
   OK=1;
   for n=1:length(mdls)
      X=CalcJacob(mdls{n},x);
      if size(X,1)<size(X,2)
         % ditch as soon as a 0 output is produced
         OK=0;
         return;
      end      
      [Q,R]=qr(X,0);
      rd= abs(diag(R));
      tol= length(X)*eps*max(rd);
      OK=  ~(size(X,2)>size(Q,1) | any(rd<tol));
      if OK==0
         % ditch as soon as a bad one is found
         return
      end
   end
else
   OK=0;
end

% attempt to place mmod back into caller workspace
nm=inputname(1);
if ~isempty(nm)
   mmod.store.rankcheck.data=OK;
   mmod.store.rankcheck.designstate=designstate(mmod);
   mmod.store.rankcheck.modelstate=modelstate(mmod);
   assignin('caller',nm,mmod);
end


