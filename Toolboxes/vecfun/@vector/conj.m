function B=conj(A)
%CONJ  Complex conjugate.
%   CONJ(V) is the complex conjugate of V.
%   For a complex V, CONJ(V) = REAL(V) - i*IMAG(V).
%
%   See also REAL, IMAG, I, J.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['conj(' A.fx ')'];
   B.fy=['conj(' A.fy ')'];
   B.fz=['conj(' A.fz ')'];
else
   B.fx=['conj(' inputname(1) '.' x ')'];
   B.fy=['conj(' inputname(1) '.' y ')'];
   B.fz=['conj(' inputname(1) '.' z ')'];
end
B.Fx=['conj(' A.Fx ')'];
B.Fy=['conj(' A.Fy ')'];
B.Fz=['conj(' A.Fz ')'];