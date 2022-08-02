% Script para aplicar Newton-Raphson a mifuncion

% Lectura de datos
% Tengo que leer la cota de error 'cota', el n�mero de iteraciones m�ximo 'n'
% y el valor inicial 'xi'

cota = input ('Cota de error objetivo: ');
n = input ('N� m�ximo de iteraciones: ');
xi = input ('Valor inicial de la x: ');

xanterior = xi;
x = xanterior;
eanterior = inf;
e = eanterior;

i = 1; % contador de iteraciones

% Voy a dibujar las tangentes mientras calculo
figure(1)
clf
hold on
fplot('mifuncion(x)',[-2 2],'b');
grid

% Debo realizar un procedimiento iterativo mientras el error sea mayor que la cota
% y el n�mero de iteraci�n sea menor que n

while (e>cota) & (i<n)
   y = mifuncion (xanterior);
   yd = mifuncion_derivada (xanterior);
   
   x = xanterior - y/yd;
   
   % Para dibujar
   yant=mifuncion(xanterior);
   plot ([xanterior x],[yant 0],'r')
   e = abs (x - xanterior);
   
   xanterior = x;
   eanterior = e;
   i=i+1;
end
hold off
% Comprobaci�n de por cual de las dos (tres) condiciones sali�
if (e<cota)
   disp ('Se encontr� la soluci�n');
   disp ('La soluci�n hallada es: ');
	x
	disp ('La cota de error es: ');
	e
	disp ('El n�mero de iteraciones utilizado es: ');
	i
	disp ('Y el valor de la funci�n en dicho punto es: ');
	mifuncion(x)
else
   disp ('Se super� el n�mero de iteraciones');
end
