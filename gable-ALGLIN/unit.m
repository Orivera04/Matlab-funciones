function u = unit(A)
%unit(A): return A scaled to be unit length
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if A > 0
  u = 1;
elseif A < 0
  u = -1;
else
  error('Can''t take unit of 0.');
end
