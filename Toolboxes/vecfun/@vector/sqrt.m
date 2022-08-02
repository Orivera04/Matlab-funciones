function B=sqrt(A)
%SQRT  Square root.
%   SQRT(V) is the square root of the vector function V.
%   Complex results are produced if any of V's components
%   is not positive.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['sqrt(' A.fx ')'];
   B.fy=['sqrt(' A.fy ')'];
   B.fz=['sqrt(' A.fz ')'];
else
   B.fx=['sqrt(' inputname(1) '.' x ')'];
   B.fy=['sqrt(' inputname(1) '.' y ')'];
   B.fz=['sqrt(' inputname(1) '.' z ')'];
end
B.Fx=['sqrt(' A.Fx ')'];
B.Fy=['sqrt(' A.Fy ')'];
B.Fz=['sqrt(' A.Fz ')'];