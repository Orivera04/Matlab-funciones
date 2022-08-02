function [ x, y ] = abm3_pece ( f, x_range, y_initial, nstep )
%
%  function [ x, y ] = abm3_pece ( f, x_range, y_initial, nstep )
%
%  ABM3_PECE uses NSTEP steps of the Adams-Bashforth-Moulton-3 PECE method to 
%  estimate Y, the solution of an ODE, at the equally spaced points X in the 
%  range X_RANGE(1) to X_RANGE(2).  
%
%  One step of the predictor, the AB3 method,
%  is followed by one step of the corrector, the AM3 method.
%
%  The name of the derivative function is F. 
%
x(1) = x_range(1);
dx = ( x_range(2) - x_range(1) ) / nstep;
y(:,1) = y_initial;
yp(:,1) = feval ( f, x(1), y(:,1) );
%
%  Since AB-3 and AM-3 need 3 old points to proceed, we start with
%  two steps of Runge-Kutta-3.  Using an explicit method like this
%  can be a bad idea, even for a few steps, for a very stiff problem.
%
for i = 1 : 2

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
%
%  We now proceed with AB-3 and AM-3.
%
for i = 3 : nstep
  x(i+1) = x(i) + dx;

  y(:,i+1) = y(:,i) + dx * ( 23.0 * yp(:,i) - 16.0 * yp(:,i-1) + 5.0 * yp(:,i-2) )/ 12.0;
  yp(:,i+1) = feval ( f, x(i+1), y(:,i+1) );

  y(:,i+1) = y(:,i) + dx * ( 5.0 * yp(:,i+1) + 8.0 * yp(:,i) - yp(:,i-1) ) / 12.0;
  yp(:,i+1) = feval ( f, x(i+1), y(:,i+1) );
end
