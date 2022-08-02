% MAXDESCENSO método del máximo descenso
%
% X          = MAXDESCENSO(A,B)
%              Aplica el metodo del maximo descenso para la resolucion 
%              del sistema AX=B
%
% X          = MAXDESCENSO(A,B,MMAX)
%              MMAX: numero max. de iteraciones
%
% X          = MAXDESCENSO(A,B,MMAX,TOL)
%              TOL tolerancia relativa. El criterio de parada es 
%              norm(B-A*X)<TOL*norm(B)
%
% X          = MAXDESCENSO(A,B,MMAX,TOL,X0)
%              X0 es el vector inicial
%
%[X,IT]      = MAXDESCENSO(A,B,MMAX,TOL,X0)
%              Devuelve en IT el numero de iteraciones calculadas
%
%[X,IT,R]    = MAXDESCENSO(A,B,MMAX,EPX,X0)
%              R es un historial del metodo: R(i) es el residuo 
%              en el paso i
%
%[X,IT,R,FL] = MAXDESCENSO(A,B,MMAX,EPX,X0)
%              FL=1 si ha habido convegencia, 0 en caso contrario
%
% Extraido del texto:
%  
%   "Matlab en cinco lecciones de numerico" 
%    por V. Dominguez y M.L. Rapun.
% 
% Más informacion en 
%
%   http://www.unavarra.es/personal/victor_dominguez

function [x,varargout]= maxDescenso(a,b,varargin)

n=length(a); x=zeros(n,1);
mmax=40; eps=1e-6;

if nargin>2
    mmax=varargin{1};
end

if nargin>3
    eps=varargin{2};
end
if (nargin>4)
    x=varargin{3};
end

res=zeros(1,mmax);
r=b-a*x; res(1)=dot(r,r); aux=norm(b);
for m=1:mmax
    p=a*r;
    xi=res(m)/dot(r,p);
    x=x+xi*r;
    r=r-xi*p;
    res(m+1)=dot(r,r);  % guardamos los residuos
    if (sqrt(res(m+1))<eps*aux);
        break
    end
end
res=res(1:m+1);
if (m==mmax) && nargout<=3
    disp('numero maximo de iteraciones sobrepasado')
end

if nargout>1
    varargout{1}=m;
end
if nargout>2
    varargout{2}=sqrt(res(:));
end
if (nargout>3)
    if m==mmax
        varargout{3}=0;
    else
        varargout{3}=1;
    end
end

return
