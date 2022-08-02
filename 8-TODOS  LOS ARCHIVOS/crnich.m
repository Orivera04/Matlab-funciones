function  U = crnich (f, c1, c2, a, b, c, n, m)

% Entrada - f  = u (x, 0)  como una cadena de caracteres  'f'
%         - c1 = u (0, t)  y  c2 = u (a, t)
%         - a  y  b  extremos derechos de  [0, a]  y  [0, b]
%         - c  la constante en la ecuacion de calor
%         - n  y  m  numero de puntos (nodos) de la cuadricula en  [0, a]  y  [0, b]
% Salida  - U  matriz solucion; analoga a la Tabla 10.5

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar parametros y de U

h = a / (n - 1);
k = b / (m - 1);
r = c ^ 2 * k / h ^ 2;
s1 = 2 + 2 / r;
s2 = 2 / r - 2;
U = zeros(n, m);

% Condiciones frontera

U(1, 1:m) = c1;
U(n, 1:m) = c2;

% Generar la primera fila

U (2:n-1, 1) = feval(f, h:h:(n-2)*h)';

% Formar la diagonal y los elementos fuera de la diagonal de  A  y
% el vector constante  B  y resolver el sistema tridiagonal  AX = B

Vd(1, 1:n) = s1 * ones(1, n);
Vd(1) = 1;
Vd(n) = 1;
Va = -ones(1, n-1);
Va(n-1) = 0;
Vc = -ones(1, n-1);
Vc(1) = 0;
Vb(1) = c1;
Vb(n) = c2;
for  j = 2:m
   for  i = 2:n-1
      Vb(i) = U(i-1, j-1) + U(i+1, j-1) + s2 * U(i, j-1);
   end
   X = trisys(Va, Vd, Vc, Vb);
   U(1:n, j) = X';
end

U = U'
