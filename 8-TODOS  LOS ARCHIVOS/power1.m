function  [lambda, V] = power1 (A, X, epsilon, max1)

% Entrada - A es una matriz  n x n
%         - X es el vector inicial  n x 1
%         - epsilon es la tolerancia
%         - max1 es el numero maximo de iteraciones
% Salida  - lambda es el valor propio (eigenvalue) dominante
%         - V es el vector propiothe (eigenvector) dominante

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar parametros

lambda = 0;
cnt = 0;
err = 1;
state = 1;

while  ((cnt <= max1)  &  (state == 1))
   Y = A * X;
   
   % Normalizar  Y
   [m, j] = max(abs(Y));
   c1 = m;
   dc = abs(lambda - c1);
   Y = (1 / c1) * Y;
   
   % Actualizar  X  y  lambda  y verificar la convergencia
   dv = norm(X - Y);
   err = max(dc, dv);
   X = Y;
   lambda = c1;
   state = 0;
   if  (err > epsilon)
      state = 1;
   end
   cnt = cnt + 1;
end

V = X;
