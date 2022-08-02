function B=conj(A)
%CONJ  Complex conjugate.
%   CONJ(S) is the complex conjugate of S.
%   For a complex S, CONJ(S) = REAL(S) - i*IMAG(S).
%
%   See also REAL, IMAG, I, J.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['conj(' A.f ')'];
else
   B.f=['conj(' inputname(1) ')'];
end
B.F=['conj(' A.F ')'];