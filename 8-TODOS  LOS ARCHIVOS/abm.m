function  A = abm (f, T, Y)

% Entrada   - f es la funcion introducida como una cadena de caracteres 'f'
%           - T es el vector de abscisas
%           - Y es el vector de ordenadas
% Comentario.  Las primeras cuatro coordenadas de T y Y deben
%              tener valores iniciales obtenidos con RK4
% Salida - A = [T', Y'] donde T es el vector de abscisas y
%          Y es el vector de ordenadas

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

n = length(T);
if  n < 5, break, end;

F = zeros(1, 4);
F = feval(f, T(1:4), Y(1:4));
h = T(2) - T(1);

for  k = 4:n-1
   % Predictor
   p = Y(k) + (h/24) * (F * [-9, 37, -59, 55]');
   T(k+1) = T(1) + h * k;
   F = [F(2), F(3), F(4), feval(f, T(k+1), p)];
   % Corrector
   Y(k+1) = Y(k) + (h/24) * (F * [1, -5, 19, 9]');
   F(4) = feval(f, T(k+1), Y(k+1));
end

A = [T', Y'];
