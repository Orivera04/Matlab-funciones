function B=imag(A)
%IMAG  Complex imaginary part.
%   IMAG(V) is the imaginary part of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['imag(' A.fx ')'];
   B.fy=['imag(' A.fy ')'];
   B.fz=['imag(' A.fz ')'];
else
   B.fx=['imag(' inputname(1) '.' x ')'];
   B.fy=['imag(' inputname(1) '.' y ')'];
   B.fz=['imag(' inputname(1) '.' z ')'];
end
B.Fx=['imag(' A.Fx ')'];
B.Fy=['imag(' A.Fy ')'];
B.Fz=['imag(' A.Fz ')'];