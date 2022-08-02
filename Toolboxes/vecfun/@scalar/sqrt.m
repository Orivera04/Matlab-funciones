function B=sqrt(A)
%SQRT  Square root.
%   SQRT(S) is the square root of the scalar function S.
%   Complex results are produced if S is not positive.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['sqrt(' A.f ')'];
else
   B.f=['sqrt(' inputname(1) ')'];
end
B.F=['sqrt(' A.F ')'];