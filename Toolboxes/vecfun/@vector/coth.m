function B=coth(A)
%COTH  Hyperbolic cotangent.
%   COTH(V) is the hyperbolic cotangent of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['coth(' A.fx ')'];
   B.fy=['coth(' A.fy ')'];
   B.fz=['coth(' A.fz ')'];
else
   B.fx=['coth(' inputname(1) '.' x ')'];
   B.fy=['coth(' inputname(1) '.' y ')'];
   B.fz=['coth(' inputname(1) '.' z ')'];
end
B.Fx=['coth(' A.Fx ')'];
B.Fy=['coth(' A.Fy ')'];
B.Fz=['coth(' A.Fz ')'];