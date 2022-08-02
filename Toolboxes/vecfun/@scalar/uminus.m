function B=uminus(A)
%-  Unary minus
%   -S negates the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   Aname=A.f;
else
   Aname=inputname(1);
end
if (any(Aname=='+') | any(Aname=='-'))
   B.f=['-(' Aname ')'];
else
   B.f=['-' Aname];
end
B.F=['-(' A.F ')'];