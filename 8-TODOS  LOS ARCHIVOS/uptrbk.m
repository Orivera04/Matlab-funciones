function  X = uptrbk (A, B)

% Entrada  - A es una matriz no singular  N x N
%	       - B es una matriz  N x 1
% Salida   - X es una matriz  N x 1 conteniendp la solucion de  AX = B.

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar  X  y la matriz de almacenamiento temporal  C
[N, N] = size(A);
X = zeros(N, 1);
C = zeros(1, N+1);

% Formar la matriz aumentada: Aug = [A | B]
Aug = [A, B];

for  p = 1:N-1
   % Pivoteo parcial para la columna  p
   [Y, j] = max(abs(Aug(p:N, p)));
   % Intercambiar las filas  p  y  j
   C = Aug(p, :);
   Aug(p, :) = Aug(j+p-1, :);
   Aug(j+p-1, :) = C;
  
   if  Aug(p, p) == 0
      'A was singular.  No unique solution'
     break
  end
  % El proceso de eliminacion para la columna  p
  for  k = p+1:N
     m = Aug(k, p) / Aug(p, p);
     Aug(k, p:N+1) = Aug(k, p:N+1) - m * Aug(p, p:N+1);
  end
end

% Substitucion hacia atras en  [U | Y]  utilizando el Programa 3.1
X = backsub(Aug(1:N, 1:N), Aug(1:N, N+1));
