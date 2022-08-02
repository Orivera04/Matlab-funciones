function B=cos(A)
%COS  Cosine.
%   COS(V) is the cosine of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['cos(' A.fx ')'];
   B.fy=['cos(' A.fy ')'];
   B.fz=['cos(' A.fz ')'];
else
   B.fx=['cos(' inputname(1) '.' x ')'];
   B.fy=['cos(' inputname(1) '.' y ')'];
   B.fz=['cos(' inputname(1) '.' z ')'];
end
B.Fx=['cos(' A.Fx ')'];
B.Fy=['cos(' A.Fy ')'];
B.Fz=['cos(' A.Fz ')'];