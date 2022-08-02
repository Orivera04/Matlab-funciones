function B=acosh(A)
%ACOSH  Inverse hyperbolic cosine.
%   ACOSH(S) is the inverse hyperbolic cosine of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['acosh(' A.f ')'];
else
   B.f=['acosh(' inputname(1) ')'];
end
B.F=['acosh(' A.F ')'];