function B=asin(A)
%ASIN  Inverse sine.
%   ASIN(S) is the arcsine of the scalar function S.
%   Complex results are obtained if ABS(S) > 1.0.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['asin(' A.f ')'];
else
   B.f=['asin(' inputname(1) ')'];
end
B.F=['asin(' A.F ')'];