function  C = lspoly (X, Y, M)

% Entrada   - X es el vector de abscisas   1 x n
%           - Y es el vector de ordenadas  1 x n
%           - M es el grado del polinomio por minimos cuadrados
% Salida    - C es la lista de coeficientes para el polinomio

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

n = length(X);
B = zeros(1:M+1);
F = zeros(n, M+1);

% Llenar las columnas de  F  con las potencias de  X

for  k = 1:M+1
   F(:, k) = X' .^ (k-1);
end

% Resolver el sistema lineal de (25)

A = F' * F;
B = F' * Y';
C = A \ B;
C = flipud(C);
