function B=log(A)
%LOG  Natural logarithm.
%   LOG(S) is the natural logarithm of the scalar function S.
%   Complex results are produced if S is not positive.
%
%   See also LOG10, EXP.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['log(' A.f ')'];
else
   B.f=['log(' inputname(1) ')'];
end
B.F=['log(' A.F ')'];