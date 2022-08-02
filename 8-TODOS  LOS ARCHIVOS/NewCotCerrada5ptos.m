% NEWCOTCERRADA5PTOS
%
% NEWCOTCERRADA5PTOS(F,A,B,N)
%  
% devuelve el valor aproximado de la integral de F entre A y B 
% con la regla compuesta de Newton Cotes de 5 ptos con N+1 puntos
% 
% F debe estar vectorizada
%
% Extraido del texto:
%
%   "Matlab en cinco lecciones de numerico"
%    por V. Dominguez y M.L. Rapun.
%
% M�s informacion en
%
%   http://www.unavarra.es/personal/victor_dominguez


function s=NewCotCerrada5ptos(f,a,b,n)
n=4*ceil(n/4);                          % n es ahora divisible por 4
h=(b-a)/n;                              % calculamos h
x=linspace(a,b,n+1);                    % construimos malla
y=feval(f,x);                           % evaluamos f en la malla
c1=14/45;
c2=64/45;
c3=8/15;
c4=64/45;
c5=28/45;
s=h*(c1*y(1)+...
    c2*sum(y(2:4:n))+c3*sum(y(3:4:n))...
    +c4*sum(y(4:4:n))+c5*sum(y(5:4:n))...
    +c1*y(n+1));        % aplicamos la regla
                       
return