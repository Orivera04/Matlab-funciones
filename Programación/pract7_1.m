function area=trapecios(a,b,m)
% Pr�ctica 7.1: Regla de los trapecios.
global fname
fname=input('Dame la funci�n f(x) entre comillas ');
if nargin < 1
   a=input('Dame el extremo izquierdo del intervalo ');
   b=input('Dame el extremo derecho del intervalo ');
end
if nargin < 3
   m=input('Dame el n�mero de subintervalos ');
end
h=(b-a)/m;
x=a:h:b;
sum=0;
for i=2:m
   sum=sum+f(x(i));
end
area=(h/2)*(f(a)+f(b)+2*sum);

function y=f(u)   % Con este "truco" se puede pedir la funci�n por pantalla
global fname      % (como "string") y, despu�s, evaluarla como si fuera una 
x=u;              % funci�n matem�tica.
y=eval(fname); 

      
