function B=log10(A)
%LOG10  Common (base 10) logarithm.
%   LOG10(V) is the base 10 logarithm of the vector function V.
%   Complex results are produced if any of V's components is not positive.
%
%   See also LOG, EXP.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['log10(' A.fx ')'];
   B.fy=['log10(' A.fy ')'];
   B.fz=['log10(' A.fz ')'];
else
   B.fx=['log10(' inputname(1) '.' x ')'];
   B.fy=['log10(' inputname(1) '.' y ')'];
   B.fz=['log10(' inputname(1) '.' z ')'];
end
B.Fx=['log10(' A.Fx ')'];
B.Fy=['log10(' A.Fy ')'];
B.Fz=['log10(' A.Fz ')'];