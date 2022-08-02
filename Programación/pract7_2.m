function area=simpson(a,b,m)
% Pr�ctica 7.2: Regla de Simpson cerrada.
global fname
fname=input('Dame la funci�n f(x) entre comillas ');
if nargin < 1
   a=input('Dame el extremo izquierdo del intervalo ');
   b=input('Dame el extremo derecho del intervalo ');
end
if nargin < 3
   m=input('Dame el n�mero de subintervalos ');
end
h=(b-a)/(2*m);
x=a:h:b;
sump=0;
for i=2:m
   sump=sump+f(x(2*i-1));
end
sumi=0;
for i=1:m
   sumi=sumi+f(x(2*i));
end
area=(h/3)*(f(a)+f(b)+2*sump+4*sumi);

function y=f(u)   % Con este "truco" se puede pedir la funci�n por pantalla
global fname      % (como "string") y, despu�s, evaluarla como si fuera una 
x=u;              % funci�n matem�tica.
y=eval(fname); 


      
