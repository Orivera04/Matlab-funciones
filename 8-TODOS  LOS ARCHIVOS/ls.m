function  L = ls (F1, F2, a, b, alpha, beta, M)

% Entrada   - F1 y F2 son los sistemas de ecuaciones de primer orden representando
%             los Problemas de Valor Inicial (P.V.I.'s) (9) and (10), respectivamente
%           - a y b son los extremos del intervalo
%           - alpha = x(a)  y  beta = x(b); las condiciones frontera
%           - M es el numero de pasos
% Salida    - L = [T', X]; donde  T'  es el vector de abscisas  M+1 x 1  y
%             X  es el vector de ordenadas  M+1 x 1

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

Za = [alpha, 0];
[T, Z] = rks4(F1, a, b, Za, M);
U = Z(:, 1);
Za = [0, 1];
[T, Z] = rks4(F2, a, b, Za, M);
V = Z(:, 1);
X = U + (beta - U(M+1)) * V / V(M+1);
L = [T', X];
