% REGLA3OCTAVOS
%
% REGLA3OCTAVOS(F,A,B,N)
%  
% devuelve el valor aproximado de la integral de F entre A y B 
% con la regla compuesta de 3/8 con N+1 puntos
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


function s=regla3Octavos(f,a,b,n)
n=3*ceil(n/3);                          % n es ahora divisible por 3
h=(b-a)/n;                              % calculamos h
x=linspace(a,b,n+1);                    % construimos malla
y=feval(f,x);                           % evaluamos f en la malla
s=3*h/4*(0.5*y(1)+...
    1.5*sum(y(2:3:n))+1.5*sum(y(3:3:n))...
    +sum(y(4:3:n))+ 0.5*y(n+1));        % aplicamos la regla
                       
return