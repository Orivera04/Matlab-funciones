function [delta,q,maxiter]=getstop(rsd)
% DES_RESPSURF/GETSTOP   Get the current stop conditions
%   [DELTA, Q, MAX]=GETSTOP(D) returns the stopping conditions
%   from the response surface design object D.  See also SETSTOP.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:36 $

% Created 3/11/99

delta=rsd.delta;
q=rsd.q;
maxiter=rsd.maxiter;

return
