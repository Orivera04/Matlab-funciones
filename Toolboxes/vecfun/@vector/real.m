function B=real(A)
%REAL  Complex real part.
%   REAL(V) is the real part of V.
%   See I or J to enter complex numbers.
%
%   See also IMAG, CONJ, ANGLE, ABS.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['real(' A.fx ')'];
   B.fy=['real(' A.fy ')'];
   B.fz=['real(' A.fz ')'];
else
   B.fx=['real(' inputname(1) '.' x ')'];
   B.fy=['real(' inputname(1) '.' y ')'];
   B.fz=['real(' inputname(1) '.' z ')'];
end
B.Fx=['real(' A.Fx ')'];
B.Fy=['real(' A.Fy ')'];
B.Fz=['real(' A.Fz ')'];