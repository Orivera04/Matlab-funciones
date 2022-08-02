function  [V, D] = jacobi1 (A, epsilon)

% Entrada - A es una matriz  n x n
%         - epsilon es la tolerancia
% Salida  - V es la matriz de vectores propios (eigenvectors)  n x n
%         - D es la matriz diagonal de valores propios (eigenvalues)

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar  V, D, y los  parametros

D = A;
[n, n]= s ize(A);
V = eye(n);
state = 1;

% Calcular la fila  p  y la columna  q  de los elementos fuera de la diagonal
% de magnitud mas grande en  A

[m1, p] = max(abs(D - diag(diag(D))));
[m2, q] = max(m1);
p = p(q);

while  (state == 1)
   % Hacer ceros  Dpq  y  Dqp
   t = D(p, q) / (D(q, q) - D(p, p));
   c = 1 / sqrt(t ^ 2 + 1);
   s = c * t;
   R = [c, s; -s, c];
   D([p, q], :) = R' * D([p, q], :);
   D(:, [p, q]) = D(:, [p, q]) * R;
   V(:, [p, q]) = V(:, [p, q]) * R;
   [m1, p] = max(abs(D - diag(diag(D))));
   [m2, q] = max(m1);
   p = p(q);
   if  (abs(D(p, q)) < epsilon * sqrt(sum(diag(D).^2) / n))
      state = 0;
   end
end

D = diag(diag(D));
