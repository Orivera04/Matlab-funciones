% Script para realizar la integral definida entre a y b por
% el método de los rectángulos

% La función está almacenada en funcion.m

% Petición de datos

a = input('Valor inferior del intervalo: ');
b = input('Valor superior del intervalo: ');
n = input('Número de subintervalos para el cálculo: ');

if a>b	% permutación si a es mayor que b
   t=a;
   a=b;
   b=t;
end
fplot('funcion(t)',[a b],'b')

ancho = (b-a)/n;
suma = 0;
for i=0:n-1
   f=funcion(a+i*ancho);
   suma=suma+ancho*f;
   if f<0
      bias=f;
   else
      bias=0;
   end
   
   rectangle('Position',[a+i*ancho 0+bias ancho abs(f)]);
end

fprintf(1,'El valor de la integral es %f\n',suma);
