function B=acot(A)
%ACOT  Inverse cotangent.
%   ACOT(S) is the inverse cotangent of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['acot(' A.f ')'];
else
   B.f=['acot(' inputname(1) ')'];
end
B.F=['acot(' A.F ')'];