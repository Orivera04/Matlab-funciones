function B=acosh(A)
%ACOSH  Inverse hyperbolic cosine.
%   ACOSH(V) is the inverse hyperbolic cosine of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['acosh(' A.fx ')'];
   B.fy=['acosh(' A.fy ')'];
   B.fz=['acosh(' A.fz ')'];
else
   B.fx=['acosh(' inputname(1) '.' x ')'];
   B.fy=['acosh(' inputname(1) '.' y ')'];
   B.fz=['acosh(' inputname(1) '.' z ')'];
end
B.Fx=['acosh(' A.Fx ')'];
B.Fy=['acosh(' A.Fy ')'];
B.Fz=['acosh(' A.Fz ')'];