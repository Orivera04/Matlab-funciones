function  T4 = taylor (df, a, b, ya, M)

% Entrada  - df = [y', y'', y''', y''''] introducida como cadena de caracteres  'df'
%            donde  y' = f(t, y)
%          - a y b son los extremos izquierdo y derecho
%          - ya es la condicion inicial  y(a)
%          - M es el numero de pasos
% Salida   - T4 = [T', Y'] donde  T  es el vector de abscisas y
%            Y  es el vector de ordenadas

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

h = (b - a) / M;
T = zeros(1, M+1);
Y = zeros(1, M+1);
T = a:h:b;
Y(1) = ya;

for  j = 1:M
   D = feval(df, T(j), Y(j));
   Y(j+1) = Y(j) + h * (D(1) + h * (D(2) / 2 + h * (D(3) / 6 + h * D(4) / 24)));
end

T4 = [T', Y'];
