function  U = finedif (f, g, a, b, c, n, m)

% Entrada - f = u (x, 0) como una cadena de caracteres  'f'
%         - g = ut (x, 0) como una cadena de caracteres  'g'
%         - a y b extremos derechos de  [0, a] y [0,b]
%         - c la constante en la ecuacion de onda
%         - n y m numero de puntos (nodos) en la rejilla  [0, a]  y  [0, b]
% Salida  - U matriz solucion; analogo a la Tabla 10.1

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar parametros y U

h = a / (n-1);
k = b / (m-1);
r = c * k / h;
r2 = r^2;
r22 = r^2 / 2;
s1 = 1 - r^2;
s2 = 2 - 2*r^2;
U = zeros (n, m);

% Calcular la primera y la segunda filas

for  i = 2:n-1
   U(i, 1) = feval(f, h*(i-1));
   U(i, 2) = s1 * feval(f, h*(i-1)) + k * feval(g, h*(i-1)) ...
            + r22 * (feval(f, h*i) + feval(f, h*(i-2)));
end
    
% Calcular las filas restantes de  U

for  j = 3:m,
  for  i = 2:(n-1),
     U(i, j) = s2 * U(i, j-1) + r2 * (U(i-1, j-1) + U(i+1, j-1)) - U(i, j-2);
  end
end

U = U';
