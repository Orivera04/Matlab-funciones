function B=tanh(A)
%TANH  Hyperbolic tangent.
%   TANH(S) is the hyperbolic tangent of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['tanh(' A.f ')'];
else
   B.f=['tanh(' inputname(1) ')'];
end
B.F=['tanh(' A.F ')'];