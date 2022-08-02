function B=cot(A)
%COT  Cotangent.
%   COT(S) is the cotangent of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['cot(' A.f ')'];
else
   B.f=['cot(' inputname(1) ')'];
end
B.F=['cot(' A.F ')'];