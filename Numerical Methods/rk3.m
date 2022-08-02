function [ x, y ] = rk3 ( f, x_range, y_initial, nstep )
%
%  function [ x, y ] = rk3 ( f, x_range, y_initial, nstep )
%
%  RK3 uses NSTEP steps of the Runge-Kutta method of order 3 to 
%  estimate Y, the solution of an ODE, at the equally spaced points X in 
%  the range X_RANGE(1) to X_RANGE(2).  The name of the derivative function 
%  is F. 
%
dx = ( x_range(2) - x_range(1) ) / nstep;

x(1) = x_range(1);
y(:,1) = y_initial;
yp(:,1) =  feval ( f, x(1), y(:,1) );

for i = 1 : nstep

  x1 = x(i) + 0.5 * dx;
  y1 = y(:,i) + 0.5 * dx * yp(:,i);
  yp1 = feval ( f, x1, y1 );

  x2 = x(i) + dx;
  y2 = y(:,i) + dx * ( 2.0 * yp1 - yp(:,i) );
  yp2 = feval ( f, x2, y2 );

  x(i+1) = x(i) + dx;
  y(:,i+1) = y(:,i) + dx * ( yp2 + 4.0 * yp1 + yp(:,i) ) / 6.0;
  yp(:,i+1) = feval ( f, x(i+1), y(:,i+1) );

end
