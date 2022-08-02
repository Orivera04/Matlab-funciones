function B=asinh(A)
%ASINH  Inverse hyperbolic sine.
%   ASINH(S) is the inverse hyperbolic sine of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['asinh(' A.f ')'];
else
   B.f=['asinh(' inputname(1) ')'];
end
B.F=['asinh(' A.F ')'];