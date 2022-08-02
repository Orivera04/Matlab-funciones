function S=vec2sca(V,dim)
%VEC2SCA  Convert vector to scalar.
%   S = VEC2SCA(V,DIM) where DIM is one of the numbers 1, 2 and 3.
%   This is the same as S = V.x, S = V.y or S = V.z.
%   Used internally by some vector methods.

% Copyright (c) 2001-04-19, B. Rasmus Anthin

[x y z]=vars(V);
switch(dim)
case 1, S=eval(['V.' x]);
case 2, S=eval(['V.' y]);
case 3, S=eval(['V.' z]);
end