function r = eq(a,b)
%eq(a,b): test if two multivectors are equal within tolerance.
%
%See also gable, eeq, ne.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
tol = 1e-15;
if isa(a,'double')
  if norm([b.m(1)-a; b.m(2:8)]) < tol
    r=1;
  else
    r=0;
  end
elseif isa(b,'double')
  if norm([a.m(1)-b; a.m(2:8)]) < tol
    r=1;
  else
    r=0;
  end
else
  if norm(a-b) < tol
    r=1;
  else
    r=0;
  end
end
