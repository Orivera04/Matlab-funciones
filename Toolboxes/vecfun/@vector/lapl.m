function L=lapl(V)
%LAPL  Laplacian of a vector.
%   L = LAPL(V) returns the Laplacian of a vector function V.
%   This corresponds to the Laplacian operation on each of the
%   three vector elements of V.
%
%   See Also DIV, GRAD, CURL.

% Copyright (c) 2001-04-20, B. Rasmus Anthin.

[x y z]=vars(V);
name=inputname(1);
if isempty(name)
   namex=V.fx;
   namey=V.fy;
   namez=V.fz;
else
   namex=[name '.' x];
   namey=[name '.' y];
   namez=[name '.' z];
end
Vx=vec2sca(V,1);Vy=vec2sca(V,2);Vz=vec2sca(V,3);
L=[lapl(Vx,namex) lapl(Vy,namey) lapl(Vz,namez)];