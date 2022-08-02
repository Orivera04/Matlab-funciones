function  X = lufact (A, B)

% Entrada  - A es una matriz  N x N
%	       - B es una matriz  N x 1
% Salida   - X es una matriz  N x 1 conteniendo la solucion a  AX = B.

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar  X, Y, la matriz de almacenamiento temporal  C,
%  y la matriz R donde se guarda la informacion de los intercambios de las filas

[N, N] = size(A);
X = zeros(N, 1);
Y = zeros(N, 1);
C = zeros(1, N);
R = 1:N;

for  p = 1:N-1
   
   % Encontrar la fila pivote para la columna  p
   [max1, j] = max(abs(A(p:N, p)));
   
   % Intercambiar las filas  p-esima  y  j-esima
      C = A(p, :);
      A(p, :) = A(j+p-1, :);
      A(j+p-1, :) = C;
      d = R(p);
      R(p) = R(j+p-1);
      R(j+p-1) = d;

   if  A(p,p) == 0
      'A is singular.  No unique solution'
      break
   end

   % Calcular el multiplicador y colocar en la porcion subdiagonal de  A
      for  k = p+1:N
         mult = A(k, p) / A(p, p);
         A(k, p) = mult;
         A(k, p+1:N) = A(k, p+1:N) - mult * A(p, p+1:N);
      end
end

% Resolver para  Y
Y(1) = B (R(1));
for  k = 2:N
   Y(k) = B(R(k)) - A(k, 1:k-1) * Y(1:k-1);
end

% Resolver para  X
X(N) = Y(N) / A(N, N);
for  k = N-1:-1:1
   X(k) = (Y(k) - A(k, k+1:N) * X(k+1:N)) / A(k,k);
end
