function B=asin(A)
%ASIN  Inverse sine.
%   ASIN(V) is the arcsine of the vector function V.
%   Complex results are obtained if ABS(V.x) > 1.0 or
%   ABS(V.y) > 1.0 or ABS(V.z) > 1.0.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['asin(' A.fx ')'];
   B.fy=['asin(' A.fy ')'];
   B.fz=['asin(' A.fz ')'];
else
   B.fx=['asin(' inputname(1) '.' x ')'];
   B.fy=['asin(' inputname(1) '.' y ')'];
   B.fz=['asin(' inputname(1) '.' z ')'];
end
B.Fx=['asin(' A.Fx ')'];
B.Fy=['asin(' A.Fy ')'];
B.Fz=['asin(' A.Fz ')'];