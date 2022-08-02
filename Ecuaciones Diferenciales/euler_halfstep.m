function [ x, y ] = euler_halfstep ( f, x_range, y_initial, nstep )
%
%  function [ x, y ] = euler_halfstep ( f, x_range, y_initial, nstep )
%
%  EULER_HALFSTEP uses NSTEP steps of Euler's halfstep method to estimate Y, 
%  the solution of an ODE, at the equally spaced points X in the range 
%  X_RANGE(1) to X_RANGE(2).  The name of the derivative function is F. 
%
x(1) = x_range(1);
dx = ( x_range(2) - x_range(1) ) / nstep;
y(:,1) = y_initial;

for i = 1 : nstep
  xhalf = x(i) + 0.5 * dx;
  yhalf = y(:,i) + 0.5 * dx * feval ( f, x(i), y(:,i) );
  x(i+1) = x(i) + dx;
  y(:,i+1) = y(:,i) + dx * feval ( f, xhalf, yhalf );
end
