function area=trapecios(a,b,m)
% Práctica 7.1: Regla de los trapecios.
global fname
fname=input('Dame la función f(x) entre comillas ');
if nargin < 1
   a=input('Dame el extremo izquierdo del intervalo ');
   b=input('Dame el extremo derecho del intervalo ');
end
if nargin < 3
   m=input('Dame el número de subintervalos ');
end
h=(b-a)/m;
x=a:h:b;
sum=0;
for i=2:m
   sum=sum+f(x(i));
end
area=(h/2)*(f(a)+f(b)+2*sum);

function y=f(u)   % Con este "truco" se puede pedir la función por pantalla
global fname      % (como "string") y, después, evaluarla como si fuera una 
x=u;              % función matemática.
y=eval(fname); 

      
