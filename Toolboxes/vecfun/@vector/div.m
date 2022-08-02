function D=div(V,name)
%DIV  Divergence of a vector field.
%   D = DIV(V[,NAME]) returns the divergence of a vector field V
%   where V has the type vector and D has the type scalar.
%
%   See also GRAD, CURL, LAPL.

% Copyright (c) 2001-04-13, B. Rasmus Anthin.
% Revision 2002-12-06

error(nargchk(1,2,nargin))
[h1 h2 h3]=coeffs(V);
D=1/(h1*h2*h3)*(...
   pdiff(h2*h3*vec2sca(V,1),1)+...
   pdiff(h1*h3*vec2sca(V,2),2)+...
   pdiff(h1*h2*vec2sca(V,3),3));

if nargin==1
   name=inputname(1);
end
if isempty(name)
   name=['(' V.fx ',' V.fy ',' V.fz ')'];
end

D=struct(D);
D.f=['del' char(183) '(' name ')'];
D=scalar(D);
