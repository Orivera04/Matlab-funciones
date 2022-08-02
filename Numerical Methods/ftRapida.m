% FTRAPIDA Transformada rápida de Fourier
%
% Y=FTRAPIDA(y)
%   devuelve en Y la transformada discreta
%   de Fourier del vector y
%
%   Es la transformada rápida, implementada de forma recursiva
%   Para un funcionamiento óptimo, la longitud del vector
%   "y" debe ser una potencia de 2
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

function Y = ftRapida(y)

y=y(:);      % y es columna ahora
n=length(y);
Y=zeros(n,1);  
if mod(n,2)==1
    % longitud impar
    w=exp(-i*2*pi*(0:n-1)/n);
    W=ones(1,n);
    for j=1:n
        Y(j)=W*y;
        W=W.*w;
    end
    Y=Y/n;
else
    Y0=ftRapida(y(1:2:end));
    Y1=ftRapida(y(2:2:end));
    w=exp(-i*2*pi*(0:n/2-1).'/n);
    Y(1:n/2)    =(Y0+w.*Y1)/2;
    Y(n/2+1:end)=(Y0-w.*Y1)/2;
end
return