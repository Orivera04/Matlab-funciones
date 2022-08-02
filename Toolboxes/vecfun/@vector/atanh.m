function B=atanh(A)
%ATANH  Inverse hyperbolic tangent.
%   ATANH(V) is the inverse hyperbolic tangent of the vector funtion V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['atanh(' A.fx ')'];
   B.fy=['atanh(' A.fy ')'];
   B.fz=['atanh(' A.fz ')'];
else
   B.fx=['atanh(' inputname(1) '.' x ')'];
   B.fy=['atanh(' inputname(1) '.' y ')'];
   B.fz=['atanh(' inputname(1) '.' z ')'];
end
B.Fx=['atanh(' A.Fx ')'];
B.Fy=['atanh(' A.Fy ')'];
B.Fz=['atanh(' A.Fz ')'];