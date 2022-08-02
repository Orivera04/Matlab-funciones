function  [T, Z] = rks4 (F, a, b, Za, M)

% Entrada   - F es el sistema introducido como cadena de caracteres  'F'
%           - a y b los extremos del intervalo
%           - Za = [x(a), y(a)] las condiciones iniciales
%           - M es el numero de pasos
% Salida    - T es el vector de pasos
%           - Z = [x1(t),  . . .,  xn(t)] donde  xk(t)  es la aproximacion a la
%             k-esima variable dependiente

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
Z = zeros(M+1, length(Za));
T = a:h:b;
Z(1, :) = Za;

for  j = 1:M
   k1 = h * feval(F, T(j), Z(j, :));
   k2 = h * feval(F, T(j) + h/2, Z(j, :) + k1/2);
   k3 = h * feval(F, T(j) + h/2, Z(j, :) + k2/2);
   k4 = h * feval(F, T(j) + h, Z(j, :) + k3);
   Z(j+1, :) = Z(j, :) + (k1 + 2 * k2 + 2 * k3 + k4) / 6;
end
