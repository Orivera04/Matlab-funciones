function r = eeq(a,b)
%eeq(a,b): test if two multivectors are equal.
%
%See also gable, eq, ne.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if isa(a,'double')
  if sum(abs(b.m(2:8)) > 0) | b.m(1) ~= a
    r=0;
  else
    r=1;
  end
elseif isa(b,'double')
  if sum(abs(a.m(2:8)) > 0) | a.m(1) ~= b
    r=0;
  else
    r=1;
  end
else
  r = prod(a.m == b.m);
end
