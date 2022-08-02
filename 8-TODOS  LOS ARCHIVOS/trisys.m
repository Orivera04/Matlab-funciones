function  X = trisys (A, D, C, B)

% Entrada - A es la sub diagonal de la matriz de coeficientes
%         - D es la diagonal principal de la matriz de coeficientes
%         - C es la diagonal superior de la matriz de coeficientes
%         - B es el vector constante del sistema lineal
% Salida  - X es el vector solucion

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

N = length(B);
for  k = 2:N
   mult = A(k-1) / D(k-1);
   D(k) = D(k) - mult * C(k-1);
   B(k) = B(k) - mult * B(k-1);
end

X(N) = B(N) / D(N);

for  k = N-1:-1:1
   X(k) = (B(k) - C(k) * X(k+1)) / D(k);
end
