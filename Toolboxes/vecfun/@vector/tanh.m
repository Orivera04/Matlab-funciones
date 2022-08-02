function B=tanh(A)
%TANH  Hyperbolic tangent.
%   TANH(V) is the hyperbolic tangent of the vector function V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   B.fx=['tanh(' A.fx ')'];
   B.fy=['tanh(' A.fy ')'];
   B.fz=['tanh(' A.fz ')'];
else
   B.fx=['tanh(' inputname(1) '.' x ')'];
   B.fy=['tanh(' inputname(1) '.' y ')'];
   B.fz=['tanh(' inputname(1) '.' z ')'];
end
B.Fx=['tanh(' A.Fx ')'];
B.Fy=['tanh(' A.Fy ')'];
B.Fz=['tanh(' A.Fz ')'];