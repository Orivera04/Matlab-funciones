function B=abs(A)
%ABS  Absolute value.
%   ABS(S) is the absolute value of the scalar function S. When
%   S is complex, ABS(S) is the complex modulus (magnitude) of S.
%
%   See also ANGLE.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['abs(' A.f ')'];
else
   B.f=['abs(' inputname(1) ')'];
end
B.F=['abs(' A.F ')'];