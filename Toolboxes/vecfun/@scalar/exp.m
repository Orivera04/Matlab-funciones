function B=exp(A)
%EXP  Exponential
%   EXP(S) is the exponential of the scalar function S.
%   For comlex Z=X+i*Y, EXP(Z) = EXP(X)*(COS(Y)+i*SIN(Y)).
%
%   See also LOG, LOG10.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['exp(' A.f ')'];
else
   B.f=['exp(' inputname(1) ')'];
end
B.F=['exp(' A.F ')'];