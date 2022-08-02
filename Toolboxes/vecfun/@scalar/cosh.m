function B=cosh(A)
%COSH  Hyperbolic cosine.
%   COSH(S) is the hyperbolic cosine of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['cosh(' A.f ')'];
else
   B.f=['cosh(' inputname(1) ')'];
end
B.F=['cosh(' A.F ')'];