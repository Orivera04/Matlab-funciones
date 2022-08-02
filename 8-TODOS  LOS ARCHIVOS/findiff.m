function  F = findiff (p, q, r, a, b, alpha, beta, N)

% Entrada - p, q, r  son las funciones coeficientes de (1)
%           introducidas como cadena de caracteres;  'p',  'q',  'r'
%         - a y b son los extremos izquierdo y derecho
%         - alpha = x(a)  y  beta = x(b)
%         - N es el numero de pasos
% Salida  - F = [T', X']: donde T' es el vector de abscisas  1 x N  y
%           X' es el vector de ordenadas  1 x N.

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar los vectores y h

T = zeros(1, N+1);
X = zeros(1, N-1);
Va = zeros(1, N-2);
Vb = zeros(1, N-1);
Vc = zeros(1, N-2);
Vd = zeros(1, N-1);
h = (b - a) / N;

% Calcular el vector constante  B  en  AX = B

Vt = a+h:h:a+h*(N-1);
Vb = -h^2 * feval(r, Vt);
Vb(1) = Vb(1) + (1+h/2*feval(p, Vt(1))) * alpha;
Vb(N-1) = Vb(N-1) + (1-h/2*feval(p, Vt(N-1))) * beta;

% Calcular la diagonal principal de  A  en  AX = B

Vd = 2 + h^2 * feval(q, Vt);

% Calcular la super diagonal de  A  en  AX = B

Vta = Vt(1, 2:N-1);
Va = -1-h/2 * feval(p, Vta);

% Calcular la sub diagonal de  A  en  AX = B

Vtc = Vt(1, 1:N-2);
Vc = -1+h/2 * feval(p, Vtc);

% Resolver  AX = B  utilizando la funcion  trisys

X = trisys (Va, Vd, Vc, Vb);
T = [a, Vt, b];
X = [alpha, X, beta];
F = [T', X'];
