function B=coth(A)
%COTH  Hyperbolic cotangent.
%   COTH(S) is the hyperbolic cotangent of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['coth(' A.f ')'];
else
   B.f=['coth(' inputname(1) ')'];
end
B.F=['coth(' A.F ')'];