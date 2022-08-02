function B=acos(A)
%ACOS  Inverse cosine.
%   ACOS(V) is the arccosine of the vector function V.
%   Complex results are obtained if ABS(V.x) > 1.0 or
%   ABS(V.y) > 1.0 or ABS(V.z) > 1.0.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['acos(' A.fx ')'];
   B.fy=['acos(' A.fy ')'];
   B.fz=['acos(' A.fz ')'];
else
   B.fx=['acos(' inputname(1) '.' x ')'];
   B.fy=['acos(' inputname(1) '.' y ')'];
   B.fz=['acos(' inputname(1) '.' z ')'];
end
B.Fx=['acos(' A.Fx ')'];
B.Fy=['acos(' A.Fy ')'];
B.Fz=['acos(' A.Fz ')'];