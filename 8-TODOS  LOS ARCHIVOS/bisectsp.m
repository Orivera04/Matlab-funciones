function  [c, err, yc] = bisectsp (f, a, b, delta)

% Entrada - f es la funcion introducida como una cadena de caracteres 'f'
%	      - a y b son los extremos izquierdo y derecho
%	      - delta es la tolerancia
% Salida  - c es el cero
%	      - yc = f(c)
% 	      - err es el error estimado para  c

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

ya = feval(f, a);
yb = feval(f, b);
if  ya*yb > 0, break, end
max1 = 1 + round((log(b-a) - log(delta)) / log(2));
for  k = 1:max1
	c = (a + b) / 2;
	yc = feval(f, c);
	if  yc == 0
		a = c;
		b = c;
	elseif  yb*yc > 0
		b = c;
		yb = yc;
	else
		a = c;
		ya = yc;
	end
	if  b-a < delta, break, end
end

c = (a + b) / 2;
err = abs(b - a);
yc = feval(f, c);
