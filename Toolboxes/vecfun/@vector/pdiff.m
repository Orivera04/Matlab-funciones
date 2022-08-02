function B=pdiff(A,dim,order)
%PDIFF  Partial differentiation.
%   W = PDIFF(V,DIM) is the first order partial derivative of the vector
%   function V along dimension DIM which could be one of 1, 2 and 3, or
%   'x', 'y', 'z', 'R', 'r', 'theta' and 'phi'.
%
%   W = PDIFF(V,DIM,N) is the N:th order partial derivative of the vector
%   function V along dimension DIM.

% Copyright (c) 2001-04-18, B. Rasmus Anthin.

error(nargchk(2,3,nargin))
A=vector(A);
B=A;
[x y z]=vars(A);
if nargin<3, order=1;end
name=inputname(1);
if isempty(name)
   namex='';namey='';namez='';
else
   namex=[name '.' x];
   namey=[name '.' y];
   namez=[name '.' z];
end
Ax=vec2sca(A,1);Ay=vec2sca(A,2);Az=vec2sca(A,3);
B=[pdiff(Ax,dim,order,namex)...
      pdiff(Ay,dim,order,namey)...
      pdiff(Az,dim,order,namez)];
