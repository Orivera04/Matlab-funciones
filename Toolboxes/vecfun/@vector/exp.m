function B=exp(A)
%EXP  Exponential
%   EXP(V) is the exponential of the vector function V.
%   For comlex Z=X+i*Y, EXP(Z) = EXP(X)*(COS(Y)+i*SIN(Y)).
%
%   See also LOG, LOG10.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['exp(' A.fx ')'];
   B.fy=['exp(' A.fy ')'];
   B.fz=['exp(' A.fz ')'];
else
   B.fx=['exp(' inputname(1) '.' x ')'];
   B.fy=['exp(' inputname(1) '.' y ')'];
   B.fz=['exp(' inputname(1) '.' z ')'];
end
B.Fx=['exp(' A.Fx ')'];
B.Fy=['exp(' A.Fy ')'];
B.Fz=['exp(' A.Fz ')'];