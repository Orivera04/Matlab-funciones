% PUNTOMEDIO
%
% PUNTOMEDIO(F,A,B,N)
%  
% devuelve el valor aproximado de la integral de F entre A y B 
% con la regla compuesta del punto medio con N puntos
% 
% F debe estar vectorizada
%
% Este programa forma parte del material auxiliar del texto
%
%   "Matlab en cinco lecciones de numerico"
%    por V. Dominguez y M.L. Rapun.
%
% Se permite la libre copia, distribucion y ejecucion con la 
% unica condicion de mencionar y el origen y autores.
%
% Mas informacion en
%
%   http://www.unavarra.es/personal/victor_dominguez


function s=puntomedio(f,a,b,n)

h=(b-a)/n;
x=linspace(a+h/2,b-h/2,n); % construimos malla
y=feval(f,x);              % evaluamos f en la malla
s=h*sum(y);                % aplicamos la regla

return