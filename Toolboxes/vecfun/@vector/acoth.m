function B=acoth(A)
%ACOTH  Inverse hyperbolic cotangent.
%   ACOTH(V) is the inverse hyperbolic cotangent of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['acoth(' A.fx ')'];
   B.fy=['acoth(' A.fy ')'];
   B.fz=['acoth(' A.fz ')'];
else
   B.fx=['acoth(' inputname(1) '.' x ')'];
   B.fy=['acoth(' inputname(1) '.' y ')'];
   B.fz=['acoth(' inputname(1) '.' z ')'];
end
B.Fx=['acoth(' A.Fx ')'];
B.Fy=['acoth(' A.Fy ')'];
B.Fz=['acoth(' A.Fz ')'];