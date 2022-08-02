function B=pdiff(A,dim,order,name)
%PDIFF  Partial differentiation.
%   T = PDIFF(S,DIM) is the first order partial derivative of the scalar
%   function S along dimension DIM which could be one of 1, 2 and 3, or
%   'x', 'y', 'z', 'R', 'r', 'theta' and 'phi'.
%
%   T = PDIFF(S,DIM,N) is the N:th order partial derivative of the scalar
%   function S along dimension DIM.

% Copyright (c) 2001-04-18, B. Rasmus Anthin.
% Revision: 2002-12-06.

error(nargchk(2,4,nargin))
B=A;
if nargin<4
   name=inputname(1);
end
if isempty(name)
   name=['(' A.f ')'];
else
   name=['(' name ')'];
end
if nargin==2
   order=1;
end
ord=int2str(order);
[x y z]=vars(A);
switch(dim)
case {1,x}
   dx=['d' x];
   var=1;
case {2,y}
   dx=['d' y];
   var=2;
case {3,z}
   dx=['d' z];
   var=3;
otherwise
   error('Wrong type of index.')
end
if order==1
   B.f=['d/' dx name];
elseif 1<order & order<4 %& strcmp(computer,'PCWIN')
   B.f=['d' char(176+order) '/' dx char(176+order) name];
else
   B.f=['d^' ord '/' dx '^' ord name];
end
B.F=['pdiffev(' x ',' y ',' z ',' A.F ',' num2str(var) ',' ord ')'];
