function B=sin(A)
%SIN  Sine.
%   SIN(V) is the sine of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['sin(' A.fx ')'];
   B.fy=['sin(' A.fy ')'];
   B.fz=['sin(' A.fz ')'];
else
   B.fx=['sin(' inputname(1) '.' x ')'];
   B.fy=['sin(' inputname(1) '.' y ')'];
   B.fz=['sin(' inputname(1) '.' z ')'];
end
B.Fx=['sin(' A.Fx ')'];
B.Fy=['sin(' A.Fy ')'];
B.Fz=['sin(' A.Fz ')'];