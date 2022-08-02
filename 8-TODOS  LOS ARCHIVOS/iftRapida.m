% IFTRAPIDA Inversa de la Transformada rápida de Fourier
%
% y=IFTRAPIDA(Y)
%   devuelve en y la inversa de la transformada discreta
%   de Fourier del vector Y
%
%   Es la transformada rápida, implementada de forma recursiva
%   Para un funcionamiento óptimo, la longitud del vector
%   "Y" debe ser una potencia de 2
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

function y = iftRapida(Y)

Y=Y(:);      % y es columna ahora
n=length(Y);
y=zeros(n,1);  
if mod(n,2)==1
    % longitud impar
    w=exp(i*2*pi*(0:n-1)/n);
    W=ones(1,n);
    for j=1:n
        y(j)=W*Y;
        W=W.*w;
    end
else
    y0=iftRapida(Y(1:2:end));
    y1=iftRapida(Y(2:2:end));
    w=exp(i*2*pi*(0:n/2-1).'/n);
    y(1:n/2)    =(y0+w.*y1);
    y(n/2+1:end)=(y0-w.*y1);
end
return