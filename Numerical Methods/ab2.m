function [ x, y ] = ab2 ( f, x_range, y_initial, nstep )
%
%  function [ x, y ] = ab2 ( f, x_range, y_initial, nstep )
%
%AB2 usa NSTEP pasos del método de Adams-Bashforth de orden 2 para 
%estimar Y,la solución de una EDO,en los puntos igualmente espaciados x 
%en el rango X_RANGE(1) a X_RANGE(2).El nombre de la función derivada es f.
%
dx = ( x_range(2) - x_range(1) ) / nstep;
x(1) = x_range(1);
y(1,1) = y_initial;
yp(1,1) =  feval ( f, [x(1), y(1,1)] );
%
%  Tomar un paso del MétodoRunge-Kutta-2 
%
i = 1;
  xhalf = x(i) + 0.5 * dx;
  yhalf = y(1,i) + 0.5 * dx * yp(1,1);
  yphalf = feval ( f, [xhalf, yhalf] );

  x(i+1) = x(i) + dx;
  y(1,i+1) = y(1,i) + dx * yphalf;
  yp(1,i+1) = feval ( f, [x(i+1), y(1,i+1)] );
%
%  Después del primer paso, procedemos con Adams-Bashforth-2.
%
for i = 2 : nstep
  x(i+1) = x(i) + dx;
  y(:,i+1) = y(:,i) + dx * ( 3.0 * yp(:,i) - yp(:,i-1) ) / 2.0;
  yp(:,i+1) = feval ( f, [x(i+1), y(:,i+1)] );
end
