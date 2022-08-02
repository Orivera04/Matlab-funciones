function B=cosh(A)
%COSH  Hyperbolic cosine.
%   COSH(V) is the hyperbolic cosine of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['cosh(' A.fx ')'];
   B.fy=['cosh(' A.fy ')'];
   B.fz=['cosh(' A.fz ')'];
else
   B.fx=['cosh(' inputname(1) '.' x ')'];
   B.fy=['cosh(' inputname(1) '.' y ')'];
   B.fz=['cosh(' inputname(1) '.' z ')'];
end
B.Fx=['cosh(' A.Fx ')'];
B.Fy=['cosh(' A.Fy ')'];
B.Fz=['cosh(' A.Fz ')'];