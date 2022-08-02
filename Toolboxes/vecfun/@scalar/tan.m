function B=tan(A)
%TAN  Tangent.
%   TAN(S) is the tangent of the scalar function S.
%
%   See also ATAN.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['tan(' A.f ')'];
else
   B.f=['tan(' inputname(1) ')'];
end
B.F=['tan(' A.F ')'];