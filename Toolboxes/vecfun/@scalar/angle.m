function B=angle(A)
%ANGLE  Phase angle.
%   ANGLE(S) returns the phase angle, in radians, of a scalar function S.
%
%   See also ABS.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['angle(' A.f ')'];
else
   B.f=['angle(' inputname(1) ')'];
end
B.F=['angle(' A.F ')'];