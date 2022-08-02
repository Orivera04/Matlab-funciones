function B=sin(A)
%SIN  Sine.
%   SIN(S) is the sine of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['sin(' A.f ')'];
else
   B.f=['sin(' inputname(1) ')'];
end
B.F=['sin(' A.F ')'];