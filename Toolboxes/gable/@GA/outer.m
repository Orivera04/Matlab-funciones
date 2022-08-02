function C = outer(m,n)
%outer(m,n): Computes the outer product of two multivectors.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if isa(m, 'double')
  m = GA([m;0;0;0;0;0;0;0]);
elseif isa(n, 'double')
  n = GA([n;0;0;0;0;0;0;0]);
end
T = GAouter(m,n);
if GAautoscalar & GAisa(T,'scalar')
  C = T.m(1);
else
  C = T;
end
