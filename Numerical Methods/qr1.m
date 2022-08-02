function  D = qr1 (A, epsilon)

% Entrada - A es una matriz tridiagonal simetrica  n x n
%         - epsilon es la tolerancia
% Salida  - D es el vector de valores propios (eigenvalues)

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar parametros

[n, n] = size(A);
m = n;

while  (m > 1)
   S = A(m-1:m, m-1:m);
   if  abs(S(2, 1)) < epsilon
      A(m, m-1) = 0;
      A(m-1, m) = 0;
    
   else
      shift = eig(S);
      [j, k] = min([abs(A(m,m) - shift(1)) abs(A(m,m) - shift(2))]);
   end
   [Q, U] = qr(A - shift(k) * eye(n));
   A = U * Q + shift(k) * eye(n);
   m = m - 1;
end

D = diag(A);
