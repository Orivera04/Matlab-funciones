function  M = milne (f, T, Y)

% Entrada   - f es la funcion introducida como una cadena de caracteres  'f'
%           - T es el vector de abscisas
%           - Y es el vector de ordenadas
% Comentario.  Las primeras cuatro coordemadas de  T  y  Y  deben
%              tener valores iniciales obtenidos con  RK4
% Salida    - M = [T', Y'] donde  T es el vector de abscisas y
%             Y es el vector de ordenadas

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
pold = 0;
yold = 0;

for  k = 4:n-1
   % Predictor
   pnew = Y(k-3) + (4 * h / 3) * (F(2:4) * [2, -1, 2]');
   % Modificador
   pmod = pnew + 28 * (yold - pold) / 29;
   T(k+1) = T(1) + h * k;
   F = [F(2), F(3), F(4), feval(f, T(k+1), pmod)];
   % Corrector
   Y(k+1) = Y(k-1) + (h / 3) * (F(2:4) * [1, 4, 1]');
   pold = pnew;
   yold = Y(k+1);
   F(4) = feval(f, T(k+1), Y(k+1));
end

M = [T', Y'];
