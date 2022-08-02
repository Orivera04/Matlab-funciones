function B=uplus(A)
%+  Unary plus.
%   +S for scalar functions is S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   Aname=A.f;
else
   Aname=inputname(1);
end
B.f=['+' Aname];
B.F=['+' A.F];