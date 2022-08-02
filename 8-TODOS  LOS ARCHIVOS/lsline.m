function  [A, B] = lsline (X, Y)

% Entrada  - X es el vector de abscisas   1 x n
%          - Y es el vector de ordenadas  1 x n
% Salida   - A es el coeficiente de  x  en  Ax + B
%          - B es el coeficiente constante en  Ax + B

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

xmean = mean(X);
ymean = mean(Y);
sumx2 = (X - xmean) * (X - xmean)';
sumxy = (Y - ymean) * (X - xmean)';
A = sumxy / sumx2;
B = ymean - A * xmean;
