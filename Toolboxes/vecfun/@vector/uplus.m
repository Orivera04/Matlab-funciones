function B=uplus(A)
%+  Unary plus.
%   +V for vector functions is V.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

As=isscalar(A);
B=A;
[x y z]=vars(A);
if isempty(inputname(1))
   Anamex=A.fx;Anamey=A.fy;Anamez=A.fz;
elseif As
   Anamex=inputname(1);Anamey=inputname(1);Anamez=inputname(1);
else
   Anamex=[inputname(1) '.' x];Anamey=[inputname(1) '.' y];Anamez=[inputname(1) '.' z];
end
B.fx=['+' Anamex];
B.fy=['+' Anamey];
B.fz=['+' Anamez];
B.Fx=['+' A.Fx];
B.Fy=['+' A.Fy];
B.Fz=['+' A.Fz];