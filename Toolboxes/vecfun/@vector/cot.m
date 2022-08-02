function B=cot(A)
%COT  Cotangent.
%   COT(V) is the cotangent of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['cot(' A.fx ')'];
   B.fy=['cot(' A.fy ')'];
   B.fz=['cot(' A.fz ')'];
else
   B.fx=['cot(' inputname(1) '.' x ')'];
   B.fy=['cot(' inputname(1) '.' y ')'];
   B.fz=['cot(' inputname(1) '.' z ')'];
end
B.Fx=['cot(' A.Fx ')'];
B.Fy=['cot(' A.Fy ')'];
B.Fz=['cot(' A.Fz ')'];