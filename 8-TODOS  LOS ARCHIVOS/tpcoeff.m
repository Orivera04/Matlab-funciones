function  [A, B] = tpcoeff (X, Y, M)

% Entrada  - X es un vector de abscisas equiespaciadas en [-pi, pi]
%          - Y es un vector de ordenadas
%          - M es el grado del polinomio trogonometrico
% Salida   - A es un vector conteniendo los coeficientes de  cos(jx)
%          - B es un vector conteniendo los coeficientes de  sen(jx)

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

N = length(X) - 1;
max1 = fix((N - 1) / 2);

if  M > max1
   M = max1;
end

A = zeros(1, M+1);
B = zeros(1, M+1);
Yends = (Y(1) + Y(N+1)) / 2;
Y(1) = Yends;
Y(N+1) = Yends;
A(1) = sum(Y);

for  j = 1:M
   A(j+1) = cos(j*X) * Y';
   B(j+1) = sin(j*X) * Y';
end

A = 2 * A / N;
B = 2 * B / N;
A(1) = A(1) / 2;
