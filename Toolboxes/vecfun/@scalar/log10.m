function B=log10(A)
%LOG10  Common (base 10) logarithm.
%   LOG10(S) is the base 10 logarithm of the scalar function S.
%   Complex results are produced if S is not positive.
%
%   See also LOG, EXP.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['log10(' A.f ')'];
else
   B.f=['log10(' inputname(1) ')'];
end
B.F=['log10(' A.F ')'];