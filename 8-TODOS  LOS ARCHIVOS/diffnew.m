function  [A, df] = diffnew (X, Y)

% Entrada   - X es el vector de abscisas  1 x n
%           - Y es el vector de ordenadas 1 x n
% Salida    - A es el vector 1 x n,  vector conteniendo los coeficientes del
%             polinomio de Newton de grado  N
%           - df es la derivada aproximada

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

A = Y;
N = length(X);

for  j = 2:N
   for  k = N:-1:j
      A(k) = (A(k) - A(k-1)) / (X(k) - X(k-j+1));
   end
end

x0 = X(1);
df = A(2);
prod = 1;
n1 = length(A) - 1;

for  k = 2:n1
   prod = prod * (x0 - X(k));
   df = df + prod * A(k+1);
end
