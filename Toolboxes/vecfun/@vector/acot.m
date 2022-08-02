function B=acot(A)
%ACOT  Inverse cotangent.
%   ACOT(V) is the inverse cotangent of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['acot(' A.fx ')'];
   B.fy=['acot(' A.fy ')'];
   B.fz=['acot(' A.fz ')'];
else
   B.fx=['acot(' inputname(1) '.' x ')'];
   B.fy=['acot(' inputname(1) '.' y ')'];
   B.fz=['acot(' inputname(1) '.' z ')'];
end
B.Fx=['acot(' A.Fx ')'];
B.Fy=['acot(' A.Fy ')'];
B.Fz=['acot(' A.Fz ')'];