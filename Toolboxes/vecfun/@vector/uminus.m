function B=uminus(A)
%-  Unary minus
%   -V negates the vector functions V.

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
if (any(Anamex=='+') | any(Anamex=='-'))
   B.fx=['-(' Anamex ')'];
else
   B.fx=['-' Anamex];
end
if (any(Anamey=='+') | any(Anamey=='-'))
   B.fy=['-(' Anamey ')'];
else
   B.fy=['-' Anamey];
end
if (any(Anamez=='+') | any(Anamez=='-'))
   B.fz=['-(' Anamez ')'];
else
   B.fz=['-' Anamez];
end
B.Fx=['-(' A.Fx ')'];
B.Fy=['-(' A.Fy ')'];
B.Fz=['-(' A.Fz ')'];