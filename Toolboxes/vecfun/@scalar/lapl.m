function L=lapl(S,name)
%LAPL  Laplacian of a scalar.
%   L = LAPL(S) returns the Laplacian of a scalar function S.
%
%   See Also DIV, GRAD, CURL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.
%Revision: 2002-11-22, 2002-12-06.

L=S;
[h1 h2 h3]=coeffs(S);
L=1/(h1*h2*h3)*(...
   pdiff(h2*h3/h1*S,1,2)+...
   pdiff(h1*h3/h2*S,2,2)+...
   pdiff(h1*h2/h3*S,3,2));

if nargin==1
   name=inputname(1);
end
if isempty(name), name=S.f;end
%ch2='^2';
%if strcmp(computer,'PCWIN')
   ch2=char(178);
%end

L.f=['del' ch2 '(' name ')'];          %Lapl -> lapl
