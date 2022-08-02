function B=asinh(A)
%ASINH  Inverse hyperbolic sine.
%   ASINH(V) is the inverse hyperbolic sine of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['asinh(' A.fx ')'];
   B.fy=['asinh(' A.fy ')'];
   B.fz=['asinh(' A.fz ')'];
else
   B.fx=['asinh(' inputname(1) '.' x ')'];
   B.fy=['asinh(' inputname(1) '.' y ')'];
   B.fz=['asinh(' inputname(1) '.' z ')'];
end
B.Fx=['asinh(' A.Fx ')'];
B.Fy=['asinh(' A.Fy ')'];
B.Fz=['asinh(' A.Fz ')'];