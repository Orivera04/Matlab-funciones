function  D = qr2 (A, epsilon)

% Entrada - A es una matriz tridiagonal simetrica  n x n
%         - epsilon es la tolerancia
% Salida  - D es el vector de valores propios (eigenvalues)  n x 1

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
D = zeros(n, 1);
B = A;

while  (m > 1)
   while  (abs(B(m, m-1)) >= epsilon)
     
      % Calcular el cambio (desplazamiento)
      S = eig(B(m-1:m, m-1:m));
      [j, k] = min([abs(B(m, m) * [1, 1]' - S)]);
      
      % Factorizacion QR de B
      [Q, U] = qr(B - S(k) * eye(m));
      
      % Calcular el siguiente B
      B = U * Q + S(k) * eye(m);      
   end
   
   % Colocar el m-esimo valor propio en  A(m, m)
   A(1:m, 1:m) = B;
   
   % Repetir el proceso en la submatriz de A  m-1 x m-1
   m = m - 1;   
   B = A(1:m, 1:m);   
end

D = diag(A);
