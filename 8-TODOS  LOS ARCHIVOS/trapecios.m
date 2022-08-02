

function area=trapecios(fun,a,b,m)
%Aproxima por la regla de los trapecios compuesta el valor de la integral 
%de una función fun(x) en un intervalo de extremos a y b tomando m+1 puntos equiespaciados. 
%Variables de entrada:
%     fun(x): funcion que se quiere integrar y que debe 
%     introducirse con notación simbolica (eg. 'g').
%     a: extremo izquierdo del intervalo
%     b: extremo derecho del intervalo 
%     m: número de puntos memos uno.    
% Variables de salida:
%     area: integral aproximada

h=(b-a)/m;
x=a:h:b;
sum=0;
for i=2:m
   sum=sum+feval(fun,x(i));
end
area=(h/2)*(feval(fun,a)+feval(fun,b)+2*sum); 



      
