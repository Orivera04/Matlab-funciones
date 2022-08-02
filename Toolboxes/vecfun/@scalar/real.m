function B=real(A)
%REAL  Complex real part.
%   REAL(S) is the real part of S.
%   See I or J to enter complex numbers.
%
%   See also IMAG, CONJ, ANGLE, ABS.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['real(' A.f ')'];
else
   B.f=['real(' inputname(1) ')'];
end
B.F=['real(' A.F ')'];