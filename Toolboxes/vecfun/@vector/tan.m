function B=tan(A)
%TAN  Tangent.
%   TAN(V) is the tangent of the vector function V.
%
%   See also ATAN.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['tan(' A.fx ')'];
   B.fy=['tan(' A.fy ')'];
   B.fz=['tan(' A.fz ')'];
else
   B.fx=['tan(' inputname(1) '.' x ')'];
   B.fy=['tan(' inputname(1) '.' y ')'];
   B.fz=['tan(' inputname(1) '.' z ')'];
end
B.Fx=['tan(' A.Fx ')'];
B.Fy=['tan(' A.Fy ')'];
B.Fz=['tan(' A.Fz ')'];