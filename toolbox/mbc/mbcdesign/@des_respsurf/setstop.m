function rsdout=setstop(rsd,delta,q,maxiter)
% DES_RESPSURF/SETSTOP   Set stopping criteria
%   D=SETSTOP(D,DELTA,Q,MAX) sets the stopping criteria
%   used for optimising the response surface model designs.  DELTA
%   is the tolerance limit below which the change in psi
%   is considered to be a fail.  Q is the number of consecutive
%   DELTA-fails that trigger a stop.  MAX is the maximum 
%   number of iterations to perform.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:57 $

% Created 3/11/99

delta=max(delta,1e-12);
rsd.delta=delta;
if nargin>2
   rsd.q=q;
   if nargin>3
      rsd.maxiter=maxiter;
   end
end

if ~nargout
   % place des back into caller workspace
   nm=inputname(1);
   assignin('caller',nm,rsd);
else
   rsdout=rsd;
end
















