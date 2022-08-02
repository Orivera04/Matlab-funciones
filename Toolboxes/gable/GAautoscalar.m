function g=GAautoscalar(f)
%GAautoscalar(f): turn on/off/query conversion of GA scalars to double.
% With no arguments, returns the current value of autoscaling (0 is off
% and 1 is on).  With one argument, sets the autoscalar value to the argument
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

% Because we can't initialize persistent variables, we will hack
%  If v is uninitialized, then it is [].  prod([])=1, so prod(v)
%  will give us the answer we want.
persistent v;
if nargin == 1
  v=f;
end
g=prod(v);
