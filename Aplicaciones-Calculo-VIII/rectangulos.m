% Script para realizar la integral definida entre a y b por
% el m�todo de los rect�ngulos

% La funci�n est� almacenada en funcion.m

% Petici�n de datos

a = input('Valor inferior del intervalo: ');
b = input('Valor superior del intervalo: ');
n = input('N�mero de subintervalos para el c�lculo: ');

if a>b	% permutaci�n si a es mayor que b
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
