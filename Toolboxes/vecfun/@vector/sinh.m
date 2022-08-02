function B=sinh(A)
%SINH  Hyperbolic sine.
%   SINH(V) is the hyperbolic sine of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['sinh(' A.fx ')'];
   B.fy=['sinh(' A.fy ')'];
   B.fz=['sinh(' A.fz ')'];
else
   B.fx=['sinh(' inputname(1) '.' x ')'];
   B.fy=['sinh(' inputname(1) '.' y ')'];
   B.fz=['sinh(' inputname(1) '.' z ')'];
end
B.Fx=['sinh(' A.Fx ')'];
B.Fy=['sinh(' A.Fy ')'];
B.Fz=['sinh(' A.Fz ')'];