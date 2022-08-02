% FT
%
% Y=FT(y)
%   devuelve en Y la transformada discreta
%   de Fourier del vector y
%   La implementacion es la directa
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

function Y = ft(y)

y=y(:);      % y es columna ahora
n=length(y);
w=exp(-i*2*pi*(0:n-1)/n);
W=ones(1,n);
Y=zeros(n,1);
for j=1:n
    Y(j)=W*y;
    W=W.*w;
end
Y=Y/n;
return