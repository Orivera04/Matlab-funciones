%POTENCIASINVERSA
%
% LB=POTENCIASINVERSA(A)
%    LB es el menor valor propio calculado
%    con el metodo de potencias inversa
%
% [LB,V]=POTENCIASINVERSA(A)
%    V es el vector propio
%
% [LB,V,NITER]=POTENCIASINVERSA(A)
%    NITER son las iteraciones calculadas
%
% LB=POTENCIASINVERSA(A,MMAX)
%    MMAX   No. maximo de iteraciones n
%
% LB=POTENCIASINVERSA(A,MMAX,EPS)
%    EPS es el criterio de parada
%
% LB=POTENCIASINVERSA(A,MMAX,EPS,V0)
%    V0 vector inicial para la iteracion
%
% Extraido del texto:
%
%   "Matlab en cinco lecciones de numerico"
%    por V. Dominguez y M.L. Rapun.
%
% Mas informacion en
%
%   http://www.unavarra.es/personal/victor_dominguez


function [lb,x,m]=potenciasinversa(a,varargin)

n=length(a);
if nargin>1 & ~isempty(varargin{1})
    mmax=varargin{1};
else
    mmax=n*2;
end
if nargin>2 & ~isempty(varargin{2})
    eps=varargin{2};
else
    eps=1e-6;
end
if nargin>3  & ~isempty(varargin{3})
    y=varargin{3};
else
    y=rand(n,1);
end

[l,u]=lu(a); 
y=y/norm(y);
for m=1:mmax
    x=u\(l\y);
    lb=y'*x;
    if norm(x-lb*y)<eps
        x=x/norm(x);
        lb=1/lb; 
        return
    end
    y=x/norm(x);
end
x=y;
lb=1/lb; 
disp('numero maximo de iteraciones superado')

return