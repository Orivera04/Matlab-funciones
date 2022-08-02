function B=atan(A)
%ATAN  Inverse tangent.
%   ATAN(S) is the arctangent of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['atan(' A.f ')'];
else
   B.f=['atan(' inputname(1) ')'];
end
B.F=['atan(' A.F ')'];