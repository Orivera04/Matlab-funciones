function  [C, D] = newpoly (X, Y)

% Entrada   - X es un vector que contiene la lista de abscisas
%           - Y es un vector que contiene la lista de ordenadas
% Saldia    - C es un vector que contiene los coeficientes del
%             polinomio interpolante de Newton
%           - D es la tabla de diferencias divididas

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

n = length(X);
D = zeros(n, n);
D(:, 1) = Y';

% Usar la formula (20) para formar la tabla de diferencias divididas

for  j = 2:n
   for  k = j:n
      D(k, j) = (D(k, j-1) - D(k-1, j-1)) / (X(k) - X(k-j+1));
   end
end

% Determinar los coeficientes del polinomio interpolante de Newton

C = D(n, n);

for  k = (n-1):-1:1
   C = conv(C, poly(X(k)));
   m = length(C);
   C(m) = C(m) + D(k, k);
end
