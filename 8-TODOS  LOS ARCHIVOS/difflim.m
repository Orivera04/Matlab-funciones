function  [L, n] = difflim (f, x, toler)

% Entrada  - f es la funcion introducida como una cadena de caracteres  'f'
%          - x es el punto de diferenciacion
%          - toler es la tolerancia deseada
% Salida   - L = [H', D', E']: H es el vector de tamaños de paso (incrementos)
%                              D es el vector de derivadas aproximadas
%                              E es el vector de las cotas de error
%          - n es la coordenada de la "mejor aproximacion"

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

max1 = 15;
h = 1;
H(1) = h;
D(1) = (feval(f, x+h) - feval(f, x-h)) / (2 * h);
E(1) = 0;
R(1) = 0;

for  n = 1:2
   h = h / 10;
   H(n+1) = h;
   D(n+1) = (feval(f, x+h) - feval(f, x-h)) / (2*h);
   E(n+1) = abs(D(n+1) - D(n));
   R(n+1) = 2*E(n+1) * (abs(D(n+1)) + abs(D(n)) + eps);
end

n = 2;

while  ((E(n) > E(n+1))  &  (R(n) > toler))  &  n < max1
   h = h / 10;
   H(n+2) = h;
   D(n+2) = (feval(f, x+h) - feval(f, x-h)) / (2*h);
   E(n+2) = abs(D(n+2) - D(n+1));
   R(n+2) = 2 * E(n+2) * (abs(D(n+2)) + abs(D(n+1)) + eps);
   n = n + 1;
end

n = length(D) - 1;
L = [H', D', E'];
