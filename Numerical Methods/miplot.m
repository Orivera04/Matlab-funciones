% MIPLOT
%
% MIPLOT(F,A,B) 
%  Dibuja la funcion F entre A y B
%
% MIPLOT(F,A,B,N) 
%  Toma N puntos entre A y B para el dibujo
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

function miplot(f,a,b,varargin)

if nargin<3
    disp('argumentos insuficientes')
end

if nargin>3
    n=varargin{1};
else
    n=200;
end
x=linspace(a,b,n); % vector con n puntos entre a y b
y=feval(f,x); % f debe estar vectorizada
plot(x,y)

return