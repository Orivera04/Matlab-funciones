function  [P0, y0, err, P] = grads (F, G, P0, max1, delta, epsilon, show)

% Entrada  - F es la funcion objetivo introducida como una cadena de caracteres  'F'
%          - G = -(1/norm(grad F)) * grad F; la direccion de la busqueda
%            introducida como una cadena de caracteres  'G'
%          - P0 es el punto inicial
%          - max1 es el numero maximo de iteraciones
%          - delta es la tolerancia para  hmin  en el parametro simple (unidimensional)
%            de minimizacion en la direccion de la busqueda
%          - epsilon es la tolerancia para el error en  y0
%          - show; si  show == 1  las iteraciones son desplegadas
% Salida   - P0 es el punto para el minimo.
%          - y0 es el valor de la funcion  F(P0)
%          - err es la estimacion del error para  y0
%          - P es un vector conteniendo las iteraciones

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

if  nargin == 5,  show = 0; end
[mm, n] = size(P0);
maxj = 10;  big = 1e8;  h = 1;
P = zeros(maxj, n+1);
len = norm(P0);
y0 = feval(F, P0);
if  (len > 1e4), h = len / 1e4; end
err = 1; cnt = 0; cond = 0;
P(cnt+1, :) = [P0, y0];

while  (cnt<max1  &  cond ~= 5  & (h > delta  |  err > epsilon))
   
  % Calcular la direccion de busqueda
  S = feval(G, P0);
  
  % Iniciar minimizacion uindimensional con los parametros cuadraticos
  P1 = P0 + h * S;
  P2 = P0 + 2 * h * S;
  y1 = feval(F, P1);
  y2 = feval(F, P2);
  cond = 0; j = 0;
  while  (j < maxj  &  cond == 0)
     len = norm(P0);
     if  (y0 < y1)
      P2 = P1;
      y2 = y1;
      h = h/2;
      P1 = P0 + h * S;
      y1 = feval(F, P1);
    else
      if  (y2 < y1)
        P1 = P2;
        y1 = y2;
        h = 2 * h;
        P2 = P0 + 2 * h * S;
        y2 = feval(F, P2);
      else
        cond = -1;
      end
    end
    j = j + 1;
    if  (h < delta), cond = 1; end
    if  (abs(h) > big  |  len > big), cond = 5; end
  end
  if  (cond == 5)
    Pmin = P1;
    ymin = y1;
  else
    d = 4 * y1 - 2 * y0 - 2 * y2;     
    if  (d < 0)
      hmin = h * (4 * y1 - 3 * y0 - y2) / d;
    else
      cond = 4;
      hmin = h / 3;
    end
    
    % Construir el siguiente punto
    Pmin = P0 + hmin * S;
    ymin = feval(F, Pmin);
    
    % Determinar la magnitud del siguiente incremento  h
    h0 = abs(hmin);
    h1 = abs(hmin - h);
    h2 = abs(hmin - 2 * h);
    if  (h0 < h), h = h0; end
    if  (h1 < h), h = h1; end
    if  (h2 < h), h = h2; end
    if  (h == 0), h = hmin; end
    if  (h < delta), cond = 1; end
    
    % Prueba de terminacion para la minimizacion
    e0 = abs(y0 - ymin);
    e1 = abs(y1 - ymin);
    e2 = abs(y2 - ymin);
    if  (e0 ~= 0  &  e0 < err), err = e0; end
    if  (e1 ~= 0  &  e1 < err), err = e1; end
    if  (e2 ~= 0  &  e2 < err), err = e2; end
    if  (e0 == 0  &  e1 == 0  &  e2 == 0), err = 0; end
    if  (err < epsilon), cond = 2; end
    if  (cond == 2  &  h < delta), cond = 3; end
 end
 cnt = cnt + 1;
 P(cnt+1, :) = [Pmin, ymin];
  P0 = Pmin;
  y0 = ymin; 
end

if  (show == 1)
   disp(P);
end
