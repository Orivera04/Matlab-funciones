function C=curl(V)
%CURL  Curl or rotation of a vector field.
%   C = CURL(V) returns the curl of a vector field V
%   where both V and C is of type vector.
%
%   See also DIV, GRAD, LAPL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.
% Revision 2002-12-06

[h1 h2 h3]=coeffs(V);
[x y z]=vars(V);
name=inputname(1);
if isempty(name)
   name=['(' V.fx ',' V.fy ',' V.fz ')'];
end
Vx=vec2sca(V,1);Vy=vec2sca(V,2);Vz=vec2sca(V,3);
h11=struct(h1);h22=struct(h2);h33=struct(h3);
C=1/(expand(h1)*expand(h2)*expand(h3))*...
   [expand(h1)*(pdiff(expand(h3)*Vz,2,1)-pdiff(expand(h2)*Vy,3,1))...
      expand(h2)*(pdiff(expand(h1)*Vx,3,1)-pdiff(expand(h3)*Vz,1,1))...
      expand(h3)*(pdiff(expand(h2)*Vy,1,1)-pdiff(expand(h1)*Vx,2,1))];
%crsymb='x';
%if strcmp(computer,'PCWIN')
   crsymb=char(215);
%end
C.fx=['(del ' crsymb ' ' name ').' x];
C.fy=['(del ' crsymb ' ' name ').' y];
C.fz=['(del ' crsymb ' ' name ').' z];
