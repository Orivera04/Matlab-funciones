function B=sinh(A)
%SINH  Hyperbolic sine.
%   SINH(S) is the hyperbolic sine of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['sinh(' A.f ')'];
else
   B.f=['sinh(' inputname(1) ')'];
end
B.F=['sinh(' A.F ')'];