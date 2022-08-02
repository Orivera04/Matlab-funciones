function B=acos(A)
%ACOS  Inverse cosine.
%   ACOS(S) is the arccosine of the scalar function S.
%   Complex results are obtained if ABS(S) > 1.0.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['acos(' A.f ')'];
else
   B.f=['acos(' inputname(1) ')'];
end
B.F=['acos(' A.F ')'];