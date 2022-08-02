% JACOBIMODIFICADO
%
% D=JACOBIMODIFICADO(A)
%    Aplica el metodo de Jacobi a A y devuelve en
%    D los valores propios;  A debe ser simetrica
%
% [D,Q]= JACOBIMODIFICADO(A)
%    Q es ortogonal con Q'AQ=D
%
% [D,Q,NITER]= JACOBIMODIFICADO(A)
%    NITER Numero de iteraciones calculadas
%
% D=JACOBIMODIFICADO(A,NMAX)
%    NMAX numero maximo de iteraciones
%
% D=JACOBIMODIFICADO(A,NMAX,EPS)
%    EPS es el criterio de parada
%
% Extraido del texto:
%
%   "Matlab en cinco lecciones de numerico"
%    por V. Dominguez y M.L. Rapun.
%
% Mas informacion en
%
%   http://www.unavarra.es/personal/victor_dominguez
%
% Extraido del texto:
%
%   "Matlab en cinco lecciones de numerico"
%    por V. Dominguez y M.L. Rapun.
%
% Mas informacion en
%
%   http://www.unavarra.es/personal/victor_dominguez

function [d,Q,m]= jacobimodificado(a,varargin)

n=length(a);

if nargin>1 & ~isempty(varargin{1})
    mmax=varargin{1};
else
    mmax=n;
end
if nargin>2 & ~isempty(varargin{2})
    eps=varargin{2};
else
    eps=1e-5;
end
Q=eye(n);

for m=1:mmax
    d=diag(a);
    normad=norm(diag(d));
    if max(max(abs(a-diag(d))))<=eps*normad
        return
    end
    p=2; q=1;
    while p<=n
        if abs(a(p,q))>eps*normad;
            %calculo sen y cos
            if abs(a(q,q)-a(p,p))<1e-9
                c=1/sqrt(2);
                s=-c*sign(a(p,q));
            else
                theta=(a(q,q)-a(p,p))/(2*a(p,q));
                t=sign(theta)/(abs(theta)+sqrt(theta^2+1));
                c=1/sqrt(t^2+1);
                s=c*t;
            end
            rot=[c s ;-s c];
            %La rotacion solo afecta a las filas y col. p y q
            a([p q],:)=rot'*a([p q],:);
            a(:,[p q])=a(:,[p q])*rot;
            Q(:,[p q])=Q(:,[p q])*rot;  % guardamos Q
        end
        q=q+1;
        if q==p
            q=1; p=p+1;
        end
    end
end
disp('numero maximo de iteraciones sobrepasado');

return