function B=acoth(A)
%ACOTH  Inverse hyperbolic cotangent.
%   ACOTH(S) is the inverse hyperbolic cotangent of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['acoth(' A.f ')'];
else
   B.f=['acoth(' inputname(1) ')'];
end
B.F=['acoth(' A.F ')'];