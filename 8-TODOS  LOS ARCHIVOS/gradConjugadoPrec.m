% GRADCONJUGADOPRECPREC Método del gradiente conjugado precondicionado
%
% X          = GRADCONJUGADOPREC(A,B)
%              Aplica el metodo del gradiente conjugado para la
%              resolucion del sistema AX=B
%
% X          = GRADCONJUGADOPREC(A,B,MMAX)
%              MMAX: numero max. de iteraciones
%
% X          = GRADCONJUGADOPREC(A,B,MMAX,TOL)
%              TOL tolerancia relativa. El criterio de parada es
%              norm(B-A*X)<TOL*norm(B)
%
% X          = GRADCONJUGADOPREC(A,B,MMAX,TOL,X0)
%              X0 es el vector inicial
%
%[X,IT]      = GRADCONJUGADOPREC(A,B,MMAX,TOL,X0)
%              Devuelve en IT el numero de iteraciones calculadas
%
%[X,IT,R]    = GRADCONJUGADOPREC(A,B,MMAX,TOL,X0)
%              R es un historial del metodo: R(i) es el residuo
%              en el paso i
%
%[X,IT,R,FL] = GRADCONJUGADOPREC(A,B,MMAX,TOL,X0)
%              FL=1 si ha habido convegencia, 0 en caso contrario
%
%[X,IT,R,FL] = GRADCONJUGADOPREC(A,B,MMAX,TOL,X0,M)
%              M es el precondicionador: M^(-1)Ax=M^(-1)b
%              M debe ser simetrica definida positiva
%
%[X,IT,R,FL] = GRADCONJUGADOPREC(A,B,MMAX,TOL,X0,M1,M2)
%              M=M1*M2 es el precondionador
%
% Extraido del texto:
%  
%   "Matlab en cinco lecciones de numerico" 
%    por V. Dominguez y M.L. Rapun.
% 
% Más informacion en 
%
%   http://www.unavarra.es/personal/victor_dominguez

function [x,varargout]= gradConjugadoPrec(a,b,varargin)

n=length(a); x=zeros(n,1); mmax=40;
tol=1e-6; precond=0;
precond=0;
if nargin>2 & ~isempty(varargin{1})
    mmax=varargin{1};
end
if nargin>3 & ~isempty(varargin{2})
    tol=varargin{2};
end
if (nargin>4) & ~isempty(varargin{3})
    x=varargin{3};
end
if (nargin>5) & ~isempty(varargin{4})
    if nargin==6 
        M=varargin{4};
        precond=1;
    else
        R1=varargin{4};
        R2=varargin{5};
        precond=2;
    end
end

res=zeros(1,mmax);
r=b-a*x; d=r; res(1)=dot(r,r);  aux=norm(b);
if precond==1
    z=M\r;
    z0=z'*r;
elseif precond==2
    z=R2\(R1\r);
    z0=z'*r;
else
    z=r;
    z0=res(1);
end
d=z;
for m=1:mmax
    p=a*d;
    xi=z0/dot(d,p);
    x=x+xi*d;
    r=r-xi*p;
    res(m+1)=dot(r,r);
    if (sqrt(res(m+1))<tol*aux);
        break
    end
    if precond==1
        z=M\r;
        z1=z'*r;
    elseif precond==2
        z=R2\(R1\r);
        z1=z'*r;
    else
        z=r;
        z1=res(m+1);
    end
    tau=z1/z0;
    d=z+tau*d;
    z0=z1;
end
res=res(1:m+1);
if (m==mmax)& nargout<=3
    disp('numero maximo de iteraciones sobrepasadas')
end

if (nargout>1)
    if m==mmax
        varargout{1}=0;
    else
        varargout{1}=1;
    end
end
if nargout>2
    varargout{2}=m;
end
if nargout>3
    varargout{3}=sqrt(res(:));
end


return
