% GRADCONJUGADO Método del gradiente conjugado
%
% X          = GRADCONJUGADO(A,B)
%              Aplica el metodo del gradiente conjugado para la 
%              resolucion del sistema AX=B
%
% X          = GRADCONJUGADO(A,B,MMAX)
%              MMAX: numero max. de iteraciones
%
% X          = GRADCONJUGADO(A,B,MMAX,TOL)
%              TOL tolerancia relativa. El criterio de parada es 
%              norm(B-A*X)<TOL*norm(B)
%
% X          = GRADCONJUGADO(A,B,MMAX,TOL,X0)
%              X0 es el vector inicial
%
%[X,IT]      = GRADCONJUGADO(A,B,MMAX,TOL,X0)
%              Devuelve en IT el numero de iteraciones calculadas
%
%[X,IT,R]    = GRADCONJUGADO(A,B,MMAX,EPX,X0)
%              R es un historial del metodo: R(i) es el residuo 
%              en el paso i
%
%[X,IT,R,FL] = GRADCONJUGADO(A,B,MMAX,EPX,X0)
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

function [x,varargout]= gradConjugado(a,b,varargin)

n=length(a); x=zeros(n,1); mmax=40;
tol=1e-6;

if nargin>2
     mmax=varargin{1};
end
if nargin>3
    tol=varargin{2};
end
if (nargin>4)
    x=varargin{4};
end

res=zeros(1,mmax);
r=b-a*x; d=r; res(1)=dot(r,r); aux=norm(b);
for m=1:mmax
    p=a*d;
    xi=res(m)/dot(d,p);
    x=x+xi*d;
    r=r-xi*p;
    res(m+1)=dot(r,r);
    if (sqrt(res(m+1))<tol*aux);
        break
    end
    tau=res(m+1)/res(m);
    d=r+tau*d;
end
res=res(1:m+1);
if (m==mmax)&& nargout<=3
    disp('numero maximo de iteraciones sobrepasadas')
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
