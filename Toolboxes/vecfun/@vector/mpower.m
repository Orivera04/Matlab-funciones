function C=mpower(A,B)
%^  Power.
%   U = V^W is V to the W power, elementwise,
%   where V and W both are vector functions.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

As=isscalar(A);Bs=isscalar(B);
A=vector(A);
B=vector(B);
if isempty(str2num(A.fx)) &...
      isempty(str2num(A.fy)) &...
      isempty(str2num(A.fz)) &...
      ~strcmp(type(A),type(B))
   B=eval([type(B) '2' type(A) '(B)']);
elseif ~strcmp(type(A),type(B))
   A=eval([type(A) '2' type(B) '(A)']);
end
[x y z]=vars(A);
C.x=[min(A.x(1),B.x(1)) max(A.x(2),B.x(2)) max(A.x(3),B.x(3))];
C.y=[min(A.y(1),B.y(1)) max(A.y(2),B.y(2)) max(A.y(3),B.y(3))];
C.z=[min(A.z(1),B.z(1)) max(A.z(2),B.z(2)) max(A.z(3),B.z(3))];
C.xval=[];C.yval=[];C.zval=[];
if ~isempty(A.xval) & ~isempty(B.xval)
   C.xval='*';
end
if ~isempty(A.yval) & ~isempty(B.yval)
   C.yval='*';
end
if ~isempty(A.zval) & ~isempty(B.zval)
   C.zval='*';
end
if isempty(inputname(1))
   Anamex=A.fx;Anamey=A.fy;Anamez=A.fz;
elseif As
   Anamex=inputname(1);Anamey=inputname(1);Anamez=inputname(1);
else
   Anamex=[inputname(1) '.' x];Anamey=[inputname(1) '.' y];Anamez=[inputname(1) '.' z];
end
if isempty(inputname(2))
   Bnamex=B.fx;Bnamey=B.fy;Bnamez=B.fz;
elseif Bs
   Bnamex=inputname(2);Bnamey=inputname(2);Bnamez=inputname(2);
else
   Bnamex=[inputname(2) '.' x];Bnamey=[inputname(2) '.' y];Bnamez=[inputname(2) '.' z];
end
findAx=any(Anamex=='+') | any(Anamex=='-') | any(Anamex=='*') | any(Anamex=='/') | any(Anamex=='\');
findAy=any(Anamey=='+') | any(Anamey=='-') | any(Anamey=='*') | any(Anamey=='/') | any(Anamey=='\');
findAz=any(Anamez=='+') | any(Anamez=='-') | any(Anamez=='*') | any(Anamez=='/') | any(Anamez=='\');
findBx=any(Bnamex=='+') | any(Bnamex=='-') | any(Bnamex=='*') | any(Bnamex=='/') | any(Bnamex=='\');
findBy=any(Bnamey=='+') | any(Bnamey=='-') | any(Bnamey=='*') | any(Bnamey=='/') | any(Bnamey=='\');
findBz=any(Bnamez=='+') | any(Bnamez=='-') | any(Bnamez=='*') | any(Bnamez=='/') | any(Bnamez=='\');
if findAx & findBx
   C.fx=['(' Anamex ')^(' Bnamex ')'];
elseif findAx & ~findBx
   C.fx=['(' Anamex ')^' Bnamex];
elseif ~findAx & findBx
   C.fx=[Anamex '^(' Bnamex ')'];
else
   C.fx=[Anamex '^' Bnamex];
end
if findAy & findBy
   C.fy=['(' Anamey ')^(' Bnamey ')'];
elseif findAy & ~findBy
   C.fy=['(' Anamey ')^' Bnamey];
elseif ~findAy & findBy
   C.fy=[Anamey '^(' Bnamey ')'];
else
   C.fy=[Anamey '^' Bnamey];
end
if findAz & findBz
   C.fz=['(' Anamez ')^(' Bnamez ')'];
elseif findAz & ~findBz
   C.fz=['(' Anamez ')^' Bnamez];
elseif ~findAz & findBz
   C.fz=[Anamez '^(' Bnamez ')'];
else
   C.fz=[Anamez '^' Bnamez];
end
C.Fx=['(' A.Fx ').^(' B.Fx ')'];
C.Fy=['(' A.Fy ').^(' B.Fy ')'];
C.Fz=['(' A.Fz ').^(' B.Fz ')'];
C.coords=A.coords;
C=vector(C);