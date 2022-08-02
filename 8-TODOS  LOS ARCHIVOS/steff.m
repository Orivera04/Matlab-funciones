function  [p, Q] = steff (f, df, p0, delta, epsilon, max1)

% Entrada - f es la funcion objetivo introducida como cadena de caracteres  'f'
%         - df es la derivada de  f  introducida como cadena de caracteres  'df'
%         - p0 es la aproximacion inicial hacia cero de  f
%         - delta es la tolerancia para  p0
%         - epsilon es la tolerancia para los valores de la funcion  y
%         - max1 es el numero maximo de iteraciones
% Salida  - p es la aproximacion de Steffensen hacia cero
%   	  - Q es la matriz conteniendo la secuencia de Steffensen

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

% Inicializar la matriz  R

R = zeros(max1, 3);
R(1, 1) = p0;

for  k = 1:max1
  for  j = 2:3

    % El denominador del metodo de Newton-Raphson es calculado
    nrdenom = feval(df, R(k, j-1));

    % La condicional calcula las aproximaciones de Newton-Raphson
    if  nrdenom == 0
      'division by zero in Newton-Raphson method'
       break		
    else
      R(k, j) = R(k, j-1) - feval(f, R(k, j-1)) / nrdenom;
    end

    % El denominador en el proceso de aceleracion de Aitkens se calcula
    aadenom = R(k, 3) - 2 * R(k, 2) + R(k, 1);

    % La condicional calcula la aproximacion de la aceleracion de Aitkens
    if  aadenom == 0
      'division by zero in Aitkens Acceleration'
      break		
    else
      R(k+1, 1) = R(k, 1) - (R(k, 2) - R(k, 1)) ^ 2 / aadenom;
    end
  end

   % Romper y terminar el programa si ocurre una division por cero
   if  (nrdenom == 0)  |  (aadenom == 0)
     break
   end

   % Los criterios de terminacion son evaluados; p y la matriz Q son determinadas
    err = abs(R(k, 1) - R(k+1, 1));
    relerr = err / (abs(R(k+1, 1)) + delta);
    y = feval(f, R(k+1, 1));
    if  (err < delta)  |  (relerr < delta)  |  (y < epsilon)
       p = R(k+1, 1);
       Q = R(1:k+1, :);
       break
    end
end
