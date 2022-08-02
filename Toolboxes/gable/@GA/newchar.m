function s = newchar(p)
%newchar(p): convert a GA object to a string proclaiming its type.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
pl = ' ';
s = '    ';
if GAisa(p,'scalar')
  s = [s 'scalar'];
elseif GAisa(p, 'vector')
  s = [s 'vector'];
elseif GAisa(p, 'bivector')
  s = [s 'bivector'];
elseif GAisa(p, 'trivector')
  s = [s 'trivector'];
else
  s = [s 'multivector'];
end
