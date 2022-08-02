function  [p, y, err] = muller (f, p0, p1, p2, delta, epsilon, max1)

% Entrada - f es la funcion objetivo introducida como una cadena de caracteres  'f'
%         - p0, p1, y p2  son las aproximaciones iniciales
%         - delta es la tolerancia para  p0, p1, y p2
%         - epsilon es la tolerancia para los valores de la funcion  y
%         - max1 es el numero maxima de iteraciones
% Salida  - p es la aproximacion de Muller hacia el cero de  f
%         - y es el valor de la funcion  y = f(p)
%         - err es el error en la aproximacion de  p.

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar las matrices  P  y  Y
P = [p0, p1, p2];
Y = feval(f, P);

% Calcular a y b en la formula (15)

for  k = 1:max1
   h0 = P(1) - P(3); h1 = P(2) - P(3); e0 = Y(1) - Y(3); e1 = Y(2) - Y(3); c = Y(3);
   denom = h1 * h0 ^ 2 - h0 * h1 ^ 2;
   a = (e0 * h1 - e1 * h0) / denom;
   b = (e1 * h0 ^ 2 - e0 * h1 ^ 2) / denom;
   
   % Suprimir cualquier raiz compleja
   if  b^2-4*a*c > 0
      disc = sqrt(b ^ 2 - 4 * a * c);
   else
      disc = 0;
   end
   
   % Encontrar la raiz mas pequeña de (17)
   if  b < 0
      disc = -disc;
   end

   z = -2 * c / (b + disc);
   p = P(3) + z;

   % Ordenar las entradas de  P  para encontrar las dos mas cerdanas a  p
   if  abs(p-P(2)) < abs(p-P(1))
      Q = [P(2), P(1), P(3)];
      P = Q;
      Y = feval(f, P);
   end
   if  abs(p-P(3)) < abs(p-P(2))
      R = [P(1), P(3), P(2)];
      P = R;
      Y = feval(f, P);
   end
   
   % Reemplazar las entradas de  P  que estan mas alejadas de  p, con el valor  p
   P(3) = p;
   Y(3) = feval(f, P(3));
   y = Y(3);
   
   % Determinar el criterio de terminacion
   err = abs(z);
   relerr = err / (abs(p) + delta);
   if  (err < delta)  |  (relerr < delta)  |  (abs(y) < epsilon)
      break
   end
end
