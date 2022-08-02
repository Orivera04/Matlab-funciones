function B=atanh(A)
%ATANH  Inverse hyperbolic tangent.
%   ATANH(S) is the inverse hyperbolic tangent of the scalar funtion S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['atanh(' A.f ')'];
else
   B.f=['atanh(' inputname(1) ')'];
end
B.F=['atanh(' A.F ')'];