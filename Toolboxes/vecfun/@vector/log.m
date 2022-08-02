function B=log(A)
%LOG  Natural logarithm.
%   LOG(V) is the natural logarithm of the vector function V.
%   Complex results are produced if any of V's components is not positive.
%
%   See also LOG10, EXP.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['log(' A.fx ')'];
   B.fy=['log(' A.fy ')'];
   B.fz=['log(' A.fz ')'];
else
   B.fx=['log(' inputname(1) '.' x ')'];
   B.fy=['log(' inputname(1) '.' y ')'];
   B.fz=['log(' inputname(1) '.' z ')'];
end
B.Fx=['log(' A.Fx ')'];
B.Fy=['log(' A.Fy ')'];
B.Fz=['log(' A.Fz ')'];