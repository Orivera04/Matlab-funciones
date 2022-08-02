% TRAPECIO
%
% TRAPECIO(F,A,B,N)
%  
% devuelve el valor aproximado de la integral de F entre A y B 
% con la regla compuesta del trapecio con N+1 puntos
% 
% F debe estar vectorizada
%
% Extraido del texto:
%
%   "Matlab en cinco lecciones de numerico"
%    por V. Dominguez y M.L. Rapun.
%
% Más informacion en
%
%   http://www.unavarra.es/personal/victor_dominguez


function s=trapecio(f,a,b,n)

h=(b-a)/n;
x=linspace(a,b,n+1); % construimos malla
y=feval(f,x);      % evaluamos f en la malla
s=h*(0.5*y(1)+sum(y(2:end-1))+0.5*y(end));        % aplicamos la regla

return