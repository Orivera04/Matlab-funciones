% RELAJACION
%
% X    = RELAJACION(A,B)
%        aplica el metodo de GAUSSSEIDEL para la resolucion del sistema AX=B
%
% X    = RELAJACION(A,B,W)
%        aplica el metodo de RELAJACION con W como párametro
%
%[X,IT]= RELAJACION(A,B,W)
%        devuelve en IT el numero de iteraciones calculadas
%
%[X,IT,ERRORES]= RELAJACION(A,B,W)
%        devuelve en ERRORES el residuo de cada iteración.
%        Proporciona un historial de la convergencia del método
%
%[X,IT,ERRORES,FLAG]= RELAJACION(A,B,W,MMAX)
%        FLAG=1 si hay convergencia, FLAG=0 en caso contrario
%
%[X,IT,ERRORES,FLAG]= RELAJACION(A,B,W,MMAX,EPS1,EPS2)
%        EPS1,EPS2 son las tolerancias absoluta y relativa. El método 
%        finaliza si norm(B-A*X)<EPS1+norm(B)*EPS2
%
%[X,IT,ERRORES,FLAG]== RELAJACION(A,B,W,MMAX,EPS1,EPS2,X0)
%        arranca el metodo con X0
%
% Versión vectorizada
%
% Extraido del texto:
%  
%   "Matlab en cinco lecciones de numerico" 
%    por V. Dominguez y M.L. Rapun.
% 
% Más informacion en 
%
%   http://www.unavarra.es/personal/victor_dominguez

function [x, varargout]=relajacion(a,b,varargin)

% valores por defecto
w=1;
n=length(a); mmax=100;
eps1=1e-4;   eps2=1e-4; % tol. absoluta y relativa
x=zeros(n,1);
if nargin>2
    w=varargin{1};
end
if nargin>3
    mmax=varargin{2};
end
if nargin>4
    eps1=varargin{3};
end
if nargin>5
    eps2=varargin{4};
end
if nargin>6
    x(:)=varargin{5}; %x es un vector columna
end

errores=zeros(1,mmax);
M=1/w*diag(diag(a))+tril(a,-1);
normab=norm(b);
r=(b-a*x);
for m=1:mmax
    error=0;
    x=x+M\r;
    r=(b-a*x); % residuo
    normar=norm(r);
    errores(m)=normar;
    % norm(x-y,2),norm(x-y,inf)
    if (normar<eps1+eps2*normab)
        break
    end
end
errores=errores(1:m);
if (m==mmax) & nargout<=3
    disp('numero maximo de iteraciones sobrepasado')
end

% salida
if (nargout>1)
    varargout{1}=m;  % no de iteraciones
end
if (nargout>2)
    varargout{2}=errores;  % diferencia entre iteraciones
end
if (nargout>3)       % flag: 1 si hay convergencia, 0 en caso contrario
    if m==mmax
        varargout{3}=0;
    else
        varargout{3}=1;
    end
end

return


errores=zeros(1,mmax);
M=1/w*diag(diag(a))+tril(a,-1);
normab=norm(b);
r=(b-a*x);
for m=1:mmax
    error=0;
    x=x+M\r;
    r=(b-a*x);
    res=norm(r); % otras normas con norm(x-y,1),norm(x-y,inf)
    if (res<eps1+eps2*normab)
        break
    end
    errores(m)=res;
end
errores=errores(1:m);
if (m==mmax)
    disp('numero maximo de iteraciones sobrepasado')
end

%salida

if (nargout>1)
    varargout{1}=m;
end

if (nargout>2)
    varargout{2}=errores;
end
if (nargout>3)
    if m==mmax
        varargout{3}=0;
    else
        varargout{3}=1;
    end
end
return
