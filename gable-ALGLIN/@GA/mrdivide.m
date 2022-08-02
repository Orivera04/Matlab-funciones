function c = mrdivide(a,b)
%mrdivide: return a*inverse(b)
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if isa(b,'GA')
    t = a*inverse(b);
else
    t = (1/b)*a;
end
if isa(t,'double')
   c = t;
elseif GAautoscalar & GAisa(t,'scalar')
   c = t.m(1);
else
   c = t;
end
