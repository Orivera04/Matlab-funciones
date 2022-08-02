function  [S, E, G] = golden (f, a, b, delta, epsilon)

% Entrada  - f es la funcion objetivo introducida como una cadena de caracteres  'f'
%          - a y b son los extremos del intervalo
%          - delta es la tolerancia para las abscisas
%          - epsilon es la tolerancia para las ordenadas
% Salida   - S = (p, yp) contiene la abscisa  p  y
%            la ordenada  yp  del minimo
%          - E = (dp, dy) contiene las estimaciones de error para  p  y  yp
%          - G es una matriz  n x 4: la k-esima fila contiene  [ak, ck, dk, bk];
%            los valores de  a, c, d,  y  b  en la k-esima iteracion

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

r1 = (sqrt(5) - 1) / 2;
r2 = r1^2;
h = b - a;
ya = feval(f, a);
yb = feval(f, b);
c = a + r2 * h;
d = a + r1 * h;
yc = feval(f, c);
yd = feval(f, d);
k = 1;
A(k) = a; B(k) = b; C(k) = c; D(k) = d;

while  (abs(yb-ya) > epsilon)  |  (h > delta)
   k = k + 1;
   if  (yc < yd)
      b = d;
      yb = yd;
      d = c;
      yd = yc;
      h = b - a;
      c = a + r2 * h;
      yc = feval(f, c);
   else
      a = c;
      ya = yc;
      c = d;
      yc = yd;
      h = b - a;
      d = a + r1 * h;
      yd = feval(f, d);
   end
   A(k) = a; B(k) = b; C(k) = c; D(k) = d;
end

dp = abs(b - a);
dy = abs(yb - ya);
p = a;
yp = ya;

if  (yb < ya)
   p = b;
   yp = yb;
end

G = [A', C', D', B'];
S = [p, yp];
E = [dp, dy];
