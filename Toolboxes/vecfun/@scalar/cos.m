function B=cos(A)
%COS  Cosine.
%   COS(S) is the cosine of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['cos(' A.f ')'];
else
   B.f=['cos(' inputname(1) ')'];
end
B.F=['cos(' A.F ')'];