% SIMPSONDAPT
%
% INTEG= SIMPSONADAPT (F,A,B)
%
% Devuelve una aproximacion de la integral de F en [A,B]
% mediante una integracion adaptativa basada en 
% la regla de Simpson. La tolerancia se fija en 1e-5
%
% INTEG= SIMPSONADAPT (F,A,B,TOL)
% 
% Se integra con tolerancia TOL
%
% [INTEG,X,FL]= SIMPSONADAPT (F,A,B,TOL,NSUBD,R)
%
% NSUBD fija el numero maximo de veces que un intervalo puede
% ser dividido. R es el factor de reducción de la tolerancia en 
% cada subdivisión de los intervalos. Por defecto es 3/4. 
% 
% La variable de salida X contienete los puntos
% los puntos utilizados en la evaluación de la integral
%
% Fl=1 si se ha podido realizar la integral dentro de la tolerancia
% prefijada, 0 en caso contrario.
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

function [integ,varargout]=simpsonAdapt(f,a,b,varargin)

global r nsub dispMensajes fl

tol=1e-5; nsub=8; r=3/4;
if nargin>3
    tol=varargin{1};
end
if nargin>4
    nsub=varargin{2};
end
if nargin>5
    r=varargin{3};
end
if nargout>2
    dispMensajes=0; % No hay mensajes por la pantalla
else
    dispMensajes=1;
end

c=(a+b)/2;
fa=feval(f,a);
fb=feval(f,b);
fc=feval(f,c);
integ=(b-a)*(fa+4*fb+fc)/6; %regla de Simpson
n=0;
x=[a b c];
[integ,x]=...
    simpsonadaptativo(f,a,c,b,fa,fc,fb,integ,tol,n,x);
x=sort(x);
%figure(5)
%subplot(211), plot(x,feval(f,x),'o-')
%subplot(212), plot(x,x*0,'o')
if nargout>1
    varargout{1}=x;
    if nargout>2
        varargout{2}=fl;
    end
end
return


function [integ,x]= simpsonadaptativo(f,a,c,b,fa,fc,fb,integ,tol,n,x)

global r nsub dispMensajes fl
d=(a+c)/2; e=(c+b)/2;
fd=feval(f,d); fe=feval(f,e);
h=(b-a)/2;
integ21=h*(fa+4*fd+fc)/6;
integ22=h*(fc+4*fe+fb)/6;
x=[x,d,e];
est=16/15*abs(integ-integ21-integ22);
if est<tol
    integ=(16*(integ21+integ22)-integ)/15;
else
    if n>=nsub
        if dispMensajes==1
            fprintf(...
                'no max de subdivisiones sobrepasadas en [%10.6d, %10.6d]\n',a,b)
        end
        fl=0;
    else
        n=n+1;
        [integ21,x]=...    
             simpsonadaptativo(f,a,d,c,fa,fd,fc,integ21,tol*r,n,x);
        [integ22,x]=...
             simpsonadaptativo(f,c,e,b,fc,fe,fb,integ22,tol*r,n,x);
    end
    integ=integ21+integ22;
end
    


