function B=atan(A)
%ATAN  Inverse tangent.
%   ATAN(V) is the arctangent of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['atan(' A.fx ')'];
   B.fy=['atan(' A.fy ')'];
   B.fz=['atan(' A.fz ')'];
else
   B.fx=['atan(' inputname(1) '.' x ')'];
   B.fy=['atan(' inputname(1) '.' y ')'];
   B.fz=['atan(' inputname(1) '.' z ')'];
end
B.Fx=['atan(' A.Fx ')'];
B.Fy=['atan(' A.Fy ')'];
B.Fz=['atan(' A.Fz ')'];