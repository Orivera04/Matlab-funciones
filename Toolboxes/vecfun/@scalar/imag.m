function B=imag(A)
%IMAG  Complex imaginary part.
%   IMAG(S) is the imaginary part of the scalar function S.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if isempty(inputname(1))
   B.f=['imag(' A.f ')'];
else
   B.f=['imag(' inputname(1) ')'];
end
B.F=['imag(' A.F ')'];